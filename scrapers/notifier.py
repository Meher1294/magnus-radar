"""
Notifier: helper para enviar emails via Resend cuando un evento nuevo
intersecta con polígonos de alerta de usuarios.
"""
import os, httpx, datetime
from supabase import create_client

RESEND_API_KEY = os.environ.get("RESEND_API_KEY", "")
RESEND_FROM = os.environ.get("RESEND_FROM", "Magnus Radar <onboarding@resend.dev>")
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")

if SUPABASE_URL and SUPABASE_KEY:
    _sb = create_client(SUPABASE_URL, SUPABASE_KEY)
else:
    _sb = None

def notificar_evento(evento_id: int, lon: float, lat: float,
                     titulo: str, descripcion: str = "",
                     fuente_url: str = "", criticidad: str = "info"):
    """
    Para un evento georreferenciado: encuentra alertas de usuarios que lo cubren
    e inserta notificaciones + envía email via Resend.
    """
    if not _sb:
        print("  [notifier] sin Supabase, skip")
        return 0

    # 1. Encontrar alertas que cubren el punto
    try:
        res = _sb.rpc("alertas_en_punto", {"p_lon": lon, "p_lat": lat}).execute()
        matches = res.data or []
    except Exception as e:
        print(f"  [notifier] error RPC: {e}")
        return 0

    if not matches:
        return 0

    print(f"  [notifier] {len(matches)} usuario(s) con alertas que cubren ({lon},{lat})")
    sent = 0
    for m in matches:
        # 2. Insertar notificación
        try:
            n = _sb.table("notificaciones").insert({
                "usuario_id": m["usuario_id"],
                "evento_id": evento_id,
                "alerta_id": m["alerta_id"],
                "canal": "email",
                "estado": "pendiente"
            }).execute()
        except Exception as e:
            print(f"  [notifier] error insert notif: {e}")
            continue

        # 3. Enviar email (si Resend configurado y notif_email=true)
        if RESEND_API_KEY and m.get("notif_email"):
            ok = send_email(m["email"], m["alerta_nombre"], titulo, descripcion, fuente_url, criticidad)
            if ok:
                try:
                    _sb.table("notificaciones").update({
                        "estado": "enviada",
                        "enviada_at": datetime.datetime.utcnow().isoformat()
                    }).eq("id", n.data[0]["id"]).execute()
                except: pass
                sent += 1
            else:
                try:
                    _sb.table("notificaciones").update({"estado": "error"}).eq("id", n.data[0]["id"]).execute()
                except: pass
    return sent


def send_email(to: str, alerta_nombre: str, titulo: str,
               descripcion: str = "", fuente_url: str = "", criticidad: str = "info") -> bool:
    if not RESEND_API_KEY:
        print(f"  [resend] sin API key, skip email a {to}")
        return False

    color = {"critica":"#EF4444","alta":"#F59E0B","media":"#3B82F6","info":"#64748B"}.get(criticidad, "#64748B")

    html = f"""
<!DOCTYPE html><html><body style="font-family:-apple-system,Arial,sans-serif;background:#f5f5f7;margin:0;padding:24px">
  <table style="max-width:560px;margin:0 auto;background:white;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.05)">
    <tr><td style="background:#0A111F;padding:18px 24px">
      <div style="color:#C97B3A;font-weight:700;font-size:18px">Magnus Radar</div>
      <div style="color:#8A98B3;font-size:11px;margin-top:2px">Inteligencia Territorial</div>
    </td></tr>
    <tr><td style="padding:24px">
      <div style="display:inline-block;background:{color}22;color:{color};font-size:11px;font-weight:600;padding:3px 8px;border-radius:3px;text-transform:uppercase;letter-spacing:0.06em;margin-bottom:10px">
        Alerta · {alerta_nombre}
      </div>
      <h2 style="font-size:18px;color:#0A111F;margin:0 0 10px 0;line-height:1.4">{titulo}</h2>
      <p style="color:#5A6680;font-size:13px;line-height:1.6;margin:8px 0 20px 0">{descripcion}</p>
      { f'<a href="{fuente_url}" style="background:#C97B3A;color:white;text-decoration:none;padding:10px 18px;border-radius:5px;font-size:13px;font-weight:500;display:inline-block">Ver fuente oficial →</a>' if fuente_url else '' }
      <div style="margin-top:24px;padding-top:16px;border-top:1px solid #E5E7EB;font-size:11px;color:#9CA3AF">
        Recibiste este correo porque tienes una alerta territorial activa en Magnus Radar.<br>
        <a href="https://meher1294.github.io/magnus-radar/" style="color:#C97B3A">Ver visor</a>
        · <a href="https://meher1294.github.io/magnus-radar/#tab=alertas" style="color:#C97B3A">Gestionar mis alertas</a>
      </div>
    </td></tr>
  </table>
</body></html>"""

    try:
        r = httpx.post("https://api.resend.com/emails",
            headers={"Authorization": f"Bearer {RESEND_API_KEY}", "Content-Type": "application/json"},
            json={"from": RESEND_FROM, "to": [to], "subject": f"[Magnus Radar] {titulo[:80]}", "html": html},
            timeout=15)
        if r.status_code in (200, 202):
            print(f"  [resend] ✓ enviado a {to}")
            return True
        print(f"  [resend] error {r.status_code}: {r.text[:200]}")
        return False
    except Exception as e:
        print(f"  [resend] excepción: {e}")
        return False
