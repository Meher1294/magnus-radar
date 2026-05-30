#!/usr/bin/env bash
# ============================================================
# Magnus Radar — Master Setup Script (idempotente, a prueba de fallos)
# ============================================================
# Uso:   bash go.sh           # ejecuta todas las fases
#        bash go.sh local     # solo Mac (git, SSH key)
#        bash go.sh supabase  # solo Supabase (migrations + seeds)
#        bash go.sh vps       # solo VPS (bootstrap + deploy)
#        bash go.sh check     # validar todo sin modificar nada
# ============================================================

set -uo pipefail   # NO -e: queremos manejar errores explícitamente

# ============ COLORES ============
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
say()  { echo -e "${BLUE}▸${NC} $*"; }
ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*" >&2; }
hdr()  { echo ""; echo -e "${BOLD}════ $* ════${NC}"; }

# ============ CONFIG ============
REPO_NAME="magnus-radar"
GITHUB_USER="Meher1294"
GITHUB_REPO="${GITHUB_USER}/${REPO_NAME}"
VPS_HOST="187.127.19.173"
VPS_USER="magnus"
VPS_PATH="/opt/magnus-radar"
SSH_KEY="${HOME}/.ssh/magnus_radar"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============ HELPERS ============
need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    err "Falta comando: $1"
    case "$1" in
      git)    echo "   Instalar: brew install git" ;;
      python3) echo "   Instalar: brew install python@3.12" ;;
      ssh)    echo "   Debería venir con macOS por defecto" ;;
      gh)     echo "   Instalar: brew install gh (opcional, para auto-crear repo GitHub)" ;;
      *)      echo "   Instalar con: brew install $1" ;;
    esac
    return 1
  fi
  return 0
}

confirm() {
  local prompt="$1"
  echo ""
  read -r -p "$(echo -e "${YELLOW}? ${prompt} [s/N]: ${NC}")" yn
  case "$yn" in [sSyY]*) return 0 ;; *) return 1 ;; esac
}

prompt_secret() {
  local var="$1"; local prompt="$2"; local current="${!var:-}"
  if [ -n "$current" ]; then
    say "$var ya seteada"
    return 0
  fi
  echo ""
  read -r -s -p "$(echo -e "${YELLOW}? ${prompt}: ${NC}")" value
  echo ""
  export "$var=$value"
}

# ============ LOAD .env si existe ============
load_env() {
  if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a; source "$SCRIPT_DIR/.env"; set +a
    ok ".env cargado"
  else
    warn ".env no existe — algunos pasos pedirán credenciales"
  fi
}

# ============================================================
# FASE 0 — PRE-FLIGHT CHECK
# ============================================================
phase_check() {
  hdr "FASE 0 — Pre-flight check"

  local fail=0
  for cmd in git python3 ssh curl openssl; do
    if need_cmd "$cmd"; then ok "$cmd"; else fail=1; fi
  done

  # Python pkgs
  if python3 -c "import psycopg2" 2>/dev/null; then
    ok "python3 psycopg2"
  else
    warn "psycopg2 no instalado — lo instalaré cuando haga falta"
  fi

  # SSH key
  if [ -f "$SSH_KEY" ]; then
    ok "SSH key existe: $SSH_KEY"
  else
    warn "SSH key no existe — se generará en fase local"
  fi

  # .env
  if [ -f "$SCRIPT_DIR/.env" ]; then
    ok ".env existe"
  else
    warn ".env no existe — copia de .env.example al ejecutar"
  fi

  # Archivos críticos
  for f in README.md docker-compose.yml db/migrations/0001_initial_schema.sql web/index.html; do
    if [ -f "$SCRIPT_DIR/$f" ]; then ok "$f"; else err "Falta $f"; fail=1; fi
  done

  [ $fail -eq 0 ] && ok "Pre-flight OK" || { err "Pre-flight con errores"; return 1; }
}

# ============================================================
# FASE 1 — LOCAL (Mac): git, SSH key, push GitHub
# ============================================================
phase_local() {
  hdr "FASE 1 — Local (Mac)"

  cd "$SCRIPT_DIR" || { err "No se pudo cd a $SCRIPT_DIR"; return 1; }

  # 1.1 Limpiar .git/ corrupto que dejó el sandbox de Claude
  if [ -d ".git" ]; then
    if ! git status >/dev/null 2>&1; then
      warn ".git corrupto detectado — eliminando..."
      rm -rf .git 2>/dev/null || sudo rm -rf .git
      ok ".git eliminado"
    fi
  fi

  # 1.2 git init si no existe
  if [ ! -d ".git" ]; then
    say "git init..."
    git init -b main >/dev/null
    git config user.email "max@xpu.cl"
    git config user.name "Max Medina (Magnus)"
    ok "Repo inicializado"
  else
    ok "Repo ya inicializado"
  fi

  # 1.3 SSH key
  if [ ! -f "$SSH_KEY" ]; then
    say "Generando SSH key (ed25519)..."
    ssh-keygen -t ed25519 -C "max@xpu.cl · magnus-radar" -f "$SSH_KEY" -N "" >/dev/null
    ok "SSH key generada: $SSH_KEY"
  else
    ok "SSH key ya existe"
  fi

  # 1.4 .env
  if [ ! -f ".env" ]; then
    say "Copiando .env.example → .env..."
    cp .env.example .env
    ok ".env creado — edítalo después con tus credenciales"
  fi

  # 1.5 Primer commit
  git add . 2>/dev/null
  if git diff --cached --quiet 2>/dev/null; then
    ok "Nada nuevo para commitear"
  else
    say "Haciendo primer commit..."
    git commit -m "feat: MVP v0.1 — Magnus Radar La Higuera" >/dev/null 2>&1
    ok "Commit creado"
  fi

  # 1.6 Remote
  if git remote get-url origin >/dev/null 2>&1; then
    ok "Remote 'origin' ya configurado"
  else
    say "Configurando remote → git@github.com:${GITHUB_REPO}.git"
    git remote add origin "git@github.com:${GITHUB_REPO}.git"
    ok "Remote configurado"
  fi

  # 1.7 Crear repo GitHub si tienes gh CLI
  if command -v gh >/dev/null 2>&1; then
    if gh auth status >/dev/null 2>&1; then
      if gh repo view "$GITHUB_REPO" >/dev/null 2>&1; then
        ok "Repo GitHub ya existe: $GITHUB_REPO"
      else
        if confirm "Crear repo PRIVADO en GitHub como ${GITHUB_REPO}?"; then
          gh repo create "$GITHUB_REPO" --private --source=. --remote=origin --push
          ok "Repo creado y pusheado"
          return 0
        fi
      fi
    else
      warn "gh CLI sin auth — corre: gh auth login"
    fi
  else
    warn "gh CLI no instalado — crea el repo manualmente en github.com/new"
    echo "        Nombre: $REPO_NAME"
    echo "        Privado, sin README ni .gitignore"
  fi

  # 1.8 Push (asume repo ya existe en GitHub)
  if confirm "Hacer 'git push -u origin main' a $GITHUB_REPO?"; then
    if git push -u origin main; then
      ok "Push exitoso"
    else
      err "Push falló. Posibles causas:"
      echo "   - El repo no existe en GitHub aún"
      echo "   - Tu SSH key no está en GitHub: cat ${SSH_KEY}.pub | pbcopy"
      echo "     y pégala en github.com → Settings → SSH and GPG keys → New SSH key"
      echo "   - El repo ya tiene commits diferentes (usa: git push -f origin main)"
    fi
  fi

  # 1.9 Mostrar SSH key pública
  echo ""
  say "Tu SSH public key (cópiala a GitHub y al VPS):"
  echo "${BOLD}"
  cat "${SSH_KEY}.pub"
  echo "${NC}"
}

# ============================================================
# FASE 2 — SUPABASE: migrations + seeds
# ============================================================
phase_supabase() {
  hdr "FASE 2 — Supabase (schema + seeds)"

  load_env

  prompt_secret SUPABASE_DB_URL "Pega tu SUPABASE_DB_URL (postgresql://postgres:[pwd]@db.xxxx.supabase.co:5432/postgres)"

  if [ -z "${SUPABASE_DB_URL:-}" ]; then
    err "SUPABASE_DB_URL vacía. Abortando fase Supabase."
    echo "   La obtienes en: Supabase Dashboard → Settings → Database → Connection string → URI"
    return 1
  fi

  # 2.1 Test conexión
  say "Probando conexión a Supabase..."
  if ! python3 -c "
import psycopg2, sys
try:
    c = psycopg2.connect('$SUPABASE_DB_URL', connect_timeout=10)
    cur = c.cursor()
    cur.execute('select version()')
    print('   →', cur.fetchone()[0][:60])
    cur.close(); c.close()
except Exception as e:
    print('ERROR:', e, file=sys.stderr)
    sys.exit(1)
" ; then
    err "No se pudo conectar a Supabase"
    return 1
  fi
  ok "Conexión OK"

  # 2.2 Verificar PostGIS
  say "Verificando extensión PostGIS..."
  python3 -c "
import psycopg2
c = psycopg2.connect('$SUPABASE_DB_URL'); cur = c.cursor()
cur.execute(\"select extname from pg_extension where extname = 'postgis'\")
if cur.fetchone():
    print('   → PostGIS instalado')
else:
    print('   → PostGIS NO instalado — el schema lo instalará')
c.close()
"

  # 2.3 Ejecutar schema
  if confirm "Ejecutar migration 0001_initial_schema.sql?"; then
    say "Ejecutando schema..."
    if PGPASSWORD="" psql "$SUPABASE_DB_URL" -f "$SCRIPT_DIR/db/migrations/0001_initial_schema.sql" >/tmp/migration.log 2>&1; then
      ok "Schema ejecutado"
    else
      err "Schema falló — log: /tmp/migration.log"
      tail -20 /tmp/migration.log
      return 1
    fi
  fi

  # 2.4 Cargar predios
  if confirm "Cargar 7.686 predios SII de La Higuera?"; then
    pip3 install -q psycopg2-binary python-dotenv --break-system-packages 2>/dev/null
    local geojson="$SCRIPT_DIR/../la-higuera-predios.geojson"
    if [ ! -f "$geojson" ]; then
      err "No encontré $geojson"
      return 1
    fi
    say "Cargando predios..."
    if python3 "$SCRIPT_DIR/db/seeds/load_predios.py" "$geojson"; then
      ok "Predios cargados"
    else
      err "Carga de predios falló"
      return 1
    fi
  fi

  # 2.5 Cargar SEIA
  if confirm "Cargar 17 proyectos SEIA de La Higuera?"; then
    say "Cargando SEIA..."
    if python3 "$SCRIPT_DIR/db/seeds/load_seia.py"; then
      ok "SEIA cargados"
    else
      err "Carga de SEIA falló"
      return 1
    fi
  fi

  # 2.6 Verificación final
  say "Verificación final..."
  python3 -c "
import psycopg2
c = psycopg2.connect('$SUPABASE_DB_URL'); cur = c.cursor()
cur.execute('select count(*) from predios where comuna_codigo = 4102')
print(f'   → Predios La Higuera: {cur.fetchone()[0]}')
cur.execute('select count(*) from proyectos_seia where comuna_codigo = 4102')
print(f'   → Proyectos SEIA: {cur.fetchone()[0]}')
cur.execute('select sum(area_ha) from predios where comuna_codigo = 4102')
ha = cur.fetchone()[0]
print(f'   → Superficie predial: {ha:,.0f} ha' if ha else '   → Superficie: 0')
c.close()
"
  ok "Fase Supabase completada"
}

# ============================================================
# FASE 3 — VPS HOSTINGER: bootstrap + deploy
# ============================================================
phase_vps() {
  hdr "FASE 3 — VPS Hostinger ($VPS_HOST)"

  if [ ! -f "$SSH_KEY" ]; then
    err "SSH key no existe. Corre primero: bash go.sh local"
    return 1
  fi

  # 3.1 Test SSH
  say "Probando SSH a ${VPS_USER}@${VPS_HOST}..."
  if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes "${VPS_USER}@${VPS_HOST}" "echo ok" 2>/dev/null | grep -q "ok"; then
    ok "SSH funcionando"
  else
    warn "SSH no funciona aún. Pasos:"
    echo "   1. Conéctate via consola web Hostinger como root"
    echo "   2. Ejecuta el bootstrap:"
    echo "      curl -fsSL https://raw.githubusercontent.com/${GITHUB_REPO}/main/deploy/bootstrap_vps.sh | bash"
    echo "      (asume que el repo ya está pusheado)"
    echo "   3. Agrega tu SSH public key:"
    echo "      echo '$(cat ${SSH_KEY}.pub)' >> /home/${VPS_USER}/.ssh/authorized_keys"
    echo "   4. Vuelve a correr: bash go.sh vps"
    return 1
  fi

  # 3.2 Verificar que VPS tenga Docker
  say "Verificando Docker en VPS..."
  if ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" "command -v docker" >/dev/null 2>&1; then
    ok "Docker instalado"
  else
    err "Docker no instalado. Corre bootstrap_vps.sh primero (como root)"
    return 1
  fi

  # 3.3 Clonar/actualizar repo en VPS
  say "Clonando/actualizando repo en VPS..."
  ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" bash <<EOF
    set -e
    if [ ! -d "$VPS_PATH/.git" ]; then
      sudo mkdir -p $VPS_PATH
      sudo chown ${VPS_USER}: $VPS_PATH
      cd $VPS_PATH
      git clone https://github.com/${GITHUB_REPO}.git .
    else
      cd $VPS_PATH
      git pull origin main
    fi
EOF

  # 3.4 .env en VPS
  say "Verificando .env en VPS..."
  if ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" "test -f $VPS_PATH/.env"; then
    ok ".env existe en VPS"
  else
    warn ".env no existe en VPS. Súbelo manualmente:"
    echo "   scp -i $SSH_KEY $SCRIPT_DIR/.env ${VPS_USER}@${VPS_HOST}:${VPS_PATH}/.env"
    if confirm "Subir .env ahora?"; then
      scp -i "$SSH_KEY" "$SCRIPT_DIR/.env" "${VPS_USER}@${VPS_HOST}:${VPS_PATH}/.env"
      ok ".env subido"
    else
      return 1
    fi
  fi

  # 3.5 docker compose up
  if confirm "Levantar stack (docker compose up -d --build)?"; then
    say "Construyendo y levantando contenedores..."
    ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker compose up -d --build"
    sleep 5
    say "Estado de contenedores:"
    ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" "cd $VPS_PATH && docker compose ps"
  fi

  # 3.6 Health check
  say "Health check de API..."
  sleep 3
  if ssh -i "$SSH_KEY" "${VPS_USER}@${VPS_HOST}" "curl -sf http://localhost:8000/health" >/dev/null 2>&1; then
    ok "API responde OK"
  else
    warn "API no responde. Revisa logs: ssh ${VPS_USER}@${VPS_HOST} 'cd $VPS_PATH && docker compose logs api'"
  fi

  # 3.7 Test externo
  say "Test externo (curl a https://${VPS_HOST})..."
  if curl -k -sf "https://${VPS_HOST}/" -o /dev/null; then
    ok "Frontend accesible públicamente"
    echo ""
    echo -e "${GREEN}${BOLD}🎉 Magnus Radar en producción:${NC}"
    echo "   https://${VPS_HOST}"
    echo "   (acepta el cert self-signed por ahora — cuando agregues dominio, será Let's Encrypt)"
  else
    warn "No accesible públicamente. Revisar firewall y Caddy."
  fi
}

# ============================================================
# MAIN
# ============================================================
case "${1:-all}" in
  check|validate)
    phase_check
    ;;
  local)
    phase_check && phase_local
    ;;
  supabase|db)
    phase_check && phase_supabase
    ;;
  vps|deploy)
    phase_check && phase_vps
    ;;
  all|"")
    phase_check && phase_local && phase_supabase && phase_vps
    hdr "🎉 Todo completado"
    ;;
  *)
    echo "Uso: bash go.sh [check|local|supabase|vps|all]"
    exit 1
    ;;
esac
