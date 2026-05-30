# Magnus Radar — La Higuera

Inteligencia territorial pública para la comuna de La Higuera, Región de Coquimbo, Chile.

**Estado actual**: MVP v0.1 — mockup operativo con datos reales (7.686 predios SII + 17 proyectos SEIA verificados).

## Stack

- **Frontend**: HTML + MapLibre GL JS (estático)
- **Backend API**: FastAPI (Python) en contenedor Docker
- **Base de datos**: Supabase (PostgreSQL 16 + PostGIS 3)
- **Reverse proxy + HTTPS**: Caddy (automático con Let's Encrypt cuando haya dominio)
- **Scrapers**: Python cron (SEIA diario, DGA semanal, SMA diario)
- **VPS**: Hostinger KVM 2 — `srv1571481.hstgr.cloud` / `187.127.19.173`
- **CI/CD**: GitHub Actions → SSH → docker compose
- **CRM**: Airtable (vía webhook desde Supabase)

## Estructura del repo

```
magnus-radar/
├── web/                    # Frontend MapLibre (servido por Caddy)
│   ├── index.html         # ← versión LIVE (consulta API real, 67 KB)
│   └── index-demo.html    # ← versión OFFLINE (datos embedded, 3.7 MB)
├── api/                    # FastAPI
│   ├── main.py
│   ├── Dockerfile
│   └── requirements.txt
├── scrapers/               # Workers Python con cron
│   ├── seia_scraper.py
│   ├── dga_scraper.py
│   ├── sma_scraper.py
│   ├── crontab
│   └── Dockerfile
├── db/
│   ├── migrations/
│   │   └── 0001_initial_schema.sql    # ← ejecutar en Supabase
│   └── seeds/
│       ├── load_predios.py
│       └── load_seia.py
├── deploy/
│   ├── Caddyfile
│   └── bootstrap_vps.sh
├── .github/
│   └── workflows/
│       └── deploy.yml
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

## Setup paso a paso

### A. Local (Mac) — preparar SSH y GitHub

**A.1. Generar SSH key (si no la tienes)**

Abre Terminal en tu Mac:

```bash
ssh-keygen -t ed25519 -C "max@xpu.cl" -f ~/.ssh/magnus_radar
# Enter para passphrase vacía o pon una (recomendado)
cat ~/.ssh/magnus_radar.pub
```

Copia la salida de `cat` (empieza con `ssh-ed25519...`). Esa es tu llave pública.

**A.2. Crear repo en GitHub**

En github.com con tu usuario `Meher1294`:
- Crear repo nuevo: `magnus-radar` (privado)
- No agregues README ni .gitignore (ya los tenemos)

**A.3. Inicializar repo local**

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
git init
git branch -M main
git add .
git commit -m "Initial commit — MVP v0.1 La Higuera"
git remote add origin git@github.com:Meher1294/magnus-radar.git
git push -u origin main
```

### B. Supabase — crear proyecto y schema

**B.1. Crear proyecto Supabase**

- Ve a [supabase.com](https://supabase.com) → New Project
- Nombre: `magnus-radar`
- Región: `South America (São Paulo)` (más cerca de Chile que US)
- Password DB: genera uno fuerte y guárdalo en 1Password
- Plan: Free (luego upgrade a Pro USD 25/mes cuando lances)

**B.2. Ejecutar schema**

- Supabase Studio → SQL Editor → New query
- Pega el contenido de `db/migrations/0001_initial_schema.sql`
- Run

**B.3. Cargar datos iniciales**

Desde tu Mac:

```bash
cd magnus-radar
cp .env.example .env
# Edita .env y completa: SUPABASE_URL, SUPABASE_DB_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY
# (los encuentras en Supabase → Settings → API y Settings → Database)

pip3 install -r api/requirements.txt --break-system-packages
python3 db/seeds/load_predios.py ../la-higuera-predios.geojson
python3 db/seeds/load_seia.py
```

Resultado esperado: `Predios en DB: 7686` y `Proyectos SEIA cargados: 17`.

### C. VPS Hostinger — bootstrap

**C.1. Acceder al VPS**

Por ahora, desde la consola web de Hostinger (hPanel → VPS → SSH browser) o via terminal:

```bash
ssh root@187.127.19.173
```

**C.2. Ejecutar bootstrap**

Ya como root en el VPS:

```bash
curl -fsSL https://raw.githubusercontent.com/Meher1294/magnus-radar/main/deploy/bootstrap_vps.sh -o /tmp/bootstrap.sh
bash /tmp/bootstrap.sh
```

(Si el repo aún no está público o estás antes del primer push, sube manualmente `deploy/bootstrap_vps.sh` con `scp` o pégalo en consola.)

**C.3. Agregar tu SSH public key**

Aún como root:

```bash
echo "ssh-ed25519 AAAA...   max@xpu.cl" >> /home/magnus/.ssh/authorized_keys
```

Reemplaza con el contenido real de `~/.ssh/magnus_radar.pub`.

**C.4. Verificar SSH desde tu Mac**

```bash
ssh -i ~/.ssh/magnus_radar magnus@187.127.19.173
# Debería entrar sin pedir contraseña.
```

**C.5. Endurecer SSH (opcional, recomendado)**

Una vez que confirmes que el SSH key funciona, deshabilita el login con password:

```bash
ssh magnus@187.127.19.173
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd
```

### D. Deploy inicial al VPS

**D.1. Clonar repo en VPS**

```bash
ssh magnus@187.127.19.173
cd /opt/magnus-radar
git clone git@github.com:Meher1294/magnus-radar.git .
# (necesitarás agregar otra SSH key del VPS a GitHub Deploy keys)
```

**D.2. Configurar .env en VPS**

```bash
cp .env.example .env
nano .env
# Completa SUPABASE_URL, SUPABASE_ANON_KEY, etc.
```

**D.3. Levantar stack**

```bash
docker compose up -d --build
docker compose ps
docker compose logs -f api
```

**D.4. Probar**

Desde tu navegador: `https://187.127.19.173` (acepta el cert self-signed por ahora).
Deberías ver el mapa de Magnus Radar consultando datos en vivo desde Supabase.

### E. GitHub Actions — deploy automático

**E.1. Generar par de claves SSH dedicado para CI**

```bash
ssh-keygen -t ed25519 -f ~/.ssh/magnus_ci -C "github-actions"
cat ~/.ssh/magnus_ci.pub
# Agrega esta llave pública en /home/magnus/.ssh/authorized_keys del VPS
```

**E.2. Agregar secrets en GitHub**

Repo → Settings → Secrets and variables → Actions → New repository secret:

| Secret | Valor |
|---|---|
| `SSH_PRIVATE_KEY` | contenido completo de `~/.ssh/magnus_ci` |
| `DEPLOY_HOST` | `187.127.19.173` |
| `DEPLOY_USER` | `magnus` |

**E.3. Test**

Haz un cambio menor, push a main, y verás el workflow ejecutarse en GitHub → Actions.

### F. Dominio (cuando lo compres)

Cuando registres `magnusradar.cl` en NIC.cl:

1. Apuntar registros A:
   - `magnusradar.cl → 187.127.19.173`
   - `www.magnusradar.cl → 187.127.19.173`
2. Editar `deploy/Caddyfile` descomentando el bloque del dominio
3. `docker compose up -d caddy` → Caddy obtiene HTTPS automático en ~30 segundos

## Dos versiones del frontend

| Archivo | Tamaño | Uso | Datos |
|---|---|---|---|
| `web/index.html` | 67 KB | Producción (servido por Caddy) | Live desde Supabase via `/api/predios` y `/api/seia` |
| `web/index-demo.html` | 3.7 MB | Demo offline / pitch sin servidor | 7.686 predios + 17 SEIA embedded |

El `index.html` detecta automáticamente la URL de la API:
- En localhost → `http://localhost:8000`
- En producción → `/api` (mismo dominio, reverse proxy por Caddy)
- Override: definir `window.MAGNUS_API_URL` antes de cargar el script

Si la API no responde, el frontend muestra una pantalla de error con el endpoint y comandos de troubleshooting (`docker compose logs api`).

## Endpoints API

| Método | Path | Descripción |
|---|---|---|
| GET | `/health` | Healthcheck |
| GET | `/api/comunas` | Lista comunas publicadas |
| GET | `/api/comunas/{codigo}/stats` | Stats agregadas |
| GET | `/api/predios?comuna=4102&sector=Los%20Choros&limit=500` | Lista predios |
| GET | `/api/predios/{id}` | Detalle predio |
| GET | `/api/seia?estado=aprobado` | Lista proyectos SEIA |
| GET | `/api/eventos?desde=2026-01-01` | Timeline eventos |
| GET | `/api/search?q=24-123` | Búsqueda |

## Roadmap inmediato

- [x] Schema Supabase + RLS
- [x] Frontend MapLibre con 7.686 predios + 17 SEIA
- [x] Docker Compose + Caddy + API + Scrapers
- [x] GitHub Actions deploy
- [ ] Cargar predios y SEIA a Supabase real
- [ ] Conectar frontend a API (reemplazar GeoJSON embedded por fetch a `/api`)
- [ ] Implementar scraper SEIA real (sig.sea.gob.cl)
- [ ] Auth Supabase + flujo Pro
- [ ] Dominio + HTTPS público
- [ ] Webhook Supabase → Airtable cuando se crea usuario Pro

## Costos operativos estimados

| Etapa | Costo mensual |
|---|---|
| MVP público (free tier todo) | USD 0 |
| Pro launch (Supabase Pro) | USD 25 |
| 10 comunas / 1000 usuarios | USD 25-40 |

## Seguridad y compliance

- Toda la data del visor proviene de fuentes públicas verificables (SII, SEIA, SMA, DGA, CBR)
- No se exponen documentos privados del proyecto Hijuela 2 ni datos sensibles
- Política de uso de fuentes públicas según Ley 20.285 (Transparencia)
- HTTPS obligatorio en producción (Caddy + Let's Encrypt)
- Row-Level Security en Supabase: cada usuario solo accede a sus propios datos
- Backups Supabase automáticos diarios (plan Pro)

## Contacto

Max Medina · max@xpu.cl · Magnus SpA
