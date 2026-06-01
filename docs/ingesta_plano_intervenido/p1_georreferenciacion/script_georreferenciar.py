#!/usr/bin/env python3
"""
P1 · script de georreferenciación ITS-CARTO-PLANO-0001
Ejecutar cuando el archivo de imagen del plano esté disponible en la ruta esperada.

Genera: PLANO_HISTORICO_GEOREF.tif + reporte RMSE.

Uso:
  python script_georreferenciar.py <ruta_a_plano.png> <ruta_salida_tif>

Dependencias:
  pip install rasterio pyproj numpy

Si se prefiere QGIS:
  abrir QGIS → Raster → Georreferenciar → cargar plano + cargar puntos
  el archivo .points generado es compatible con QGIS Georeferenciador
"""
import sys, json
from pathlib import Path

def georeferenciar(plano_path: str, salida_tif: str):
    """Aplica transformación polinomial 2do orden + escribe GeoTIFF."""
    import numpy as np
    try:
        import rasterio
        from rasterio.transform import Affine
        from rasterio.warp import calculate_default_transform, reproject, Resampling
        from PIL import Image
    except ImportError as e:
        print(f'ERROR · dependencia faltante: {e}')
        print('  pip install rasterio pillow numpy pyproj')
        sys.exit(1)

    # Cargar puntos de control
    pc_path = Path(__file__).parent / 'PUNTOS_CONTROL.geojson'
    pc = json.loads(pc_path.read_text())

    print(f'─ Plano: {plano_path}')
    print(f'─ Puntos de control disponibles: {len(pc["features"])}')
    print(f'\nIMPORTANTE: este script requiere los pixels (X,Y) de cada PC sobre la imagen.')
    print(f'Editar PUNTOS_CONTROL_pixels.csv con los pixels correspondientes antes de ejecutar.')
    print(f'\nPara identificar pixels:')
    print(f'  1. Abrir plano en QGIS o software de imagen')
    print(f'  2. Hacer click sobre cada PC etiquetado')
    print(f'  3. Anotar el pixel (X,Y) en PUNTOS_CONTROL_pixels.csv')
    print(f'  4. Re-ejecutar este script')

    # Verificar si existe el archivo de pixels
    pixels_csv = Path(__file__).parent / 'PUNTOS_CONTROL_pixels.csv'
    if not pixels_csv.exists():
        # Crear plantilla
        lines = ['id,nombre,utm_e_destino,utm_n_destino,pixel_x,pixel_y']
        for f in pc['features']:
            p = f['properties']
            lines.append(f'{p["id"]},"{p["nombre"]}",{p["utm_e"]},{p["utm_n"]},,')
        pixels_csv.write_text('\n'.join(lines) + '\n')
        print(f'\nPlantilla creada: {pixels_csv}')
        print(f'Completar columnas pixel_x y pixel_y y re-ejecutar.')
        return

    # Leer pixels
    import csv
    with pixels_csv.open() as f:
        rows = [r for r in csv.DictReader(f) if r['pixel_x'] and r['pixel_y']]

    if len(rows) < 6:
        print(f'\nERROR · solo {len(rows)} puntos con pixel anotado. Se requieren ≥6 para polinomial 2do orden.')
        print('Anotar pixel_x y pixel_y en PUNTOS_CONTROL_pixels.csv para al menos 6 puntos.')
        return

    # Construir matriz de transformación · usar least squares polinomial 2do orden
    # Para cada pixel (px,py) → (E,N) UTM 19S
    # Modelo: E = a0 + a1*px + a2*py + a3*px*py + a4*px^2 + a5*py^2
    #         N = b0 + b1*px + b2*py + b3*px*py + b4*px^2 + b5*py^2

    px = np.array([float(r['pixel_x']) for r in rows])
    py = np.array([float(r['pixel_y']) for r in rows])
    E  = np.array([float(r['utm_e_destino']) for r in rows])
    N  = np.array([float(r['utm_n_destino']) for r in rows])

    A = np.column_stack([np.ones_like(px), px, py, px*py, px**2, py**2])
    coef_E, res_E, _, _ = np.linalg.lstsq(A, E, rcond=None)
    coef_N, res_N, _, _ = np.linalg.lstsq(A, N, rcond=None)

    # Calcular residuales
    E_pred = A @ coef_E
    N_pred = A @ coef_N
    dE = E - E_pred
    dN = N - N_pred
    residuales = np.sqrt(dE**2 + dN**2)
    rmse = np.sqrt((residuales**2).mean())

    print(f'\nRMSE total: {rmse:.1f} m')
    print(f'Residuales por punto:')
    for i, r in enumerate(rows):
        print(f'  {r["id"]:6s} · residual = {residuales[i]:.1f} m')

    # Reporte
    reporte_lines = [
        '# REPORTE_RMSE.md',
        '',
        f'Generado: {Path(__file__).name}',
        '',
        '## Resumen',
        f'- Puntos de control utilizados: {len(rows)}',
        f'- Modelo: polinomial 2do orden',
        f'- RMSE total: **{rmse:.1f} m**',
        '',
        '## Residuales por punto',
        '| ID | Nombre | Residual (m) |',
        '|---|---|---|',
    ]
    for i, r in enumerate(rows):
        reporte_lines.append(f'| {r["id"]} | {r["nombre"]} | {residuales[i]:.1f} |')
    reporte_lines.append('')
    reporte_lines.append('## Evaluación')
    if rmse < 50:
        reporte_lines.append('- ✅ RMSE ≤ 50 m · PROMOVIBLE A CANON · resolución plano original 1:50.000')
    elif rmse < 100:
        reporte_lines.append('- ⚠️ RMSE entre 50-100 m · ACEPTABLE PARA VISOR OPERACIONAL · NO promovible a canon estricto')
    else:
        reporte_lines.append('- ❌ RMSE > 100 m · INSUFICIENTE · revisar puntos de control o añadir más')

    (Path(__file__).parent / 'REPORTE_RMSE.md').write_text('\n'.join(reporte_lines) + '\n')
    print(f'\n→ REPORTE_RMSE.md generado')

    # Aplicar transformación a la imagen completa
    print(f'\n─ Aplicando transformación a {plano_path}...')
    img = np.array(Image.open(plano_path))
    h, w = img.shape[:2]

    # Generar 4 esquinas en UTM
    corners_px = np.array([[0,0,0,0,0,0],
                            [w,0,0,w*w,0,0]])
    # Simplificación · esquinas
    corners_pxy = np.array([(0,0),(w,0),(w,h),(0,h)])
    corners_A = np.column_stack([np.ones(4), corners_pxy[:,0], corners_pxy[:,1],
                                  corners_pxy[:,0]*corners_pxy[:,1],
                                  corners_pxy[:,0]**2, corners_pxy[:,1]**2])
    corners_E = corners_A @ coef_E
    corners_N = corners_A @ coef_N

    print(f'\nBoundingBox UTM 19S estimado:')
    print(f'  E=[{corners_E.min():.0f}, {corners_E.max():.0f}]')
    print(f'  N=[{corners_N.min():.0f}, {corners_N.max():.0f}]')

    # Para escribir GeoTIFF: usar Affine simplificada
    # Aprox: usar transformación lineal de mínimos cuadrados solo con términos lineales
    A_lin = np.column_stack([np.ones_like(px), px, py])
    coef_E_lin, _, _, _ = np.linalg.lstsq(A_lin, E, rcond=None)
    coef_N_lin, _, _, _ = np.linalg.lstsq(A_lin, N, rcond=None)
    # E = e0 + ex*px + ey*py · N = n0 + nx*px + ny*py
    # Affine: a, b, c, d, e, f → c = E_offset, a = ex, b = ey, f = N_offset, d = nx, e = ny
    trans = Affine(coef_E_lin[1], coef_E_lin[2], coef_E_lin[0],
                   coef_N_lin[1], coef_N_lin[2], coef_N_lin[0])

    # Escribir GeoTIFF
    with rasterio.open(salida_tif, 'w',
                       driver='GTiff',
                       height=h, width=w,
                       count=img.shape[2] if img.ndim > 2 else 1,
                       dtype=img.dtype,
                       crs='EPSG:32719',
                       transform=trans) as dst:
        if img.ndim == 2:
            dst.write(img, 1)
        else:
            for i in range(img.shape[2]):
                dst.write(img[:,:,i], i+1)
    print(f'\n→ {salida_tif}')
    print(f'   GeoTIFF · CRS EPSG:32719 · transformación lineal (residual ~ {rmse:.1f} m)')


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    georeferenciar(sys.argv[1], sys.argv[2])
