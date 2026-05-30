#!/usr/bin/env bash
# Magnus Radar — Setup GitHub + Pages (idempotente, a prueba de fallos)
# Uso: bash setup-github.sh

set -uo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $*"; }
say()  { echo -e "${BLUE}▸${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*" >&2; }
hdr()  { echo ""; echo -e "${BOLD}════ $* ════${NC}"; }

REPO="Meher1294/magnus-radar"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

hdr "Magnus Radar → GitHub Pages"

# 1. Limpiar .git corrupto si existe
if [ -d ".git" ]; then
  if ! git status >/dev/null 2>&1; then
    warn ".git corrupto — limpiando..."
    rm -rf .git 2>/dev/null || sudo rm -rf .git
  fi
fi

# 2. git init
if [ ! -d ".git" ]; then
  say "git init..."
  git init -b main >/dev/null
  git config user.email "max@xpu.cl"
  git config user.name "Max Medina"
  ok "Repo inicializado"
else
  ok "Repo ya inicializado"
fi

# 3. Verificar que el HTML tenga las credenciales correctas
if grep -qE 'SUPABASE_ANON *= *window\.SUPABASE_ANON *\|\| *"PEGA_AQUI_TU_ANON_KEY"' web/index.html 2>/dev/null; then
  err "web/index.html aún tiene placeholder PEGA_AQUI_TU_ANON_KEY — algo salió mal"
  exit 1
fi
if grep -q "curqkgujgtimlutinhgu" web/index.html 2>/dev/null; then
  ok "Frontend apunta a Supabase magnus-radar ✓"
fi

# 4. Commit
git add . >/dev/null
if git diff --cached --quiet 2>/dev/null; then
  ok "Nada nuevo para commitear"
else
  say "Commit..."
  git commit -m "feat: Magnus Radar v0.1 La Higuera — frontend + Supabase live

- 7.686 predios SII reales cargados a Supabase magnus-radar
- 17 proyectos SEIA verificados (Dominga, Cruz Grande, etc.)
- Frontend MapLibre conectado directo a Supabase REST
- GitHub Pages deploy via workflow" >/dev/null 2>&1
  ok "Commit creado"
fi

# 5. Remote
if git remote get-url origin >/dev/null 2>&1; then
  ok "Remote ya configurado"
else
  say "Agregando remote → git@github.com:${REPO}.git"
  git remote add origin "git@github.com:${REPO}.git"
fi

# 6. Crear repo y push
hdr "Push a GitHub"

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  # Ruta automática con gh CLI
  if gh repo view "$REPO" >/dev/null 2>&1; then
    ok "Repo ya existe: $REPO"
    say "Push..."
    git push -u origin main 2>&1 || git push -f -u origin main
  else
    say "Creando repo $REPO (privado) y pusheando..."
    gh repo create "$REPO" --private --source=. --remote=origin --push
  fi
  ok "Código en GitHub"

  # Habilitar Pages
  hdr "Activando GitHub Pages"
  say "Configurando Pages (source: GitHub Actions)..."
  gh api -X POST "repos/${REPO}/pages" \
    -f "build_type=workflow" 2>/dev/null && ok "Pages activado" \
    || warn "Pages quizás ya estaba activo (revisar manualmente)"

  say "Esperando primer deploy (~60s)..."
  sleep 5
  echo ""
  ok "URL pública (espera ~1-2 min al primer deploy):"
  echo -e "   ${BOLD}https://meher1294.github.io/magnus-radar/${NC}"
  echo ""
  echo "Ver progreso del deploy:"
  echo "   gh run watch -R $REPO"
  echo ""

else
  # Ruta manual sin gh CLI
  warn "gh CLI no disponible o sin auth"
  echo ""
  echo "Opción A — Instalar gh CLI (recomendado, 1 vez):"
  echo "   brew install gh && gh auth login"
  echo "   Luego vuelve a correr: bash setup-github.sh"
  echo ""
  echo "Opción B — Manual (3 pasos):"
  echo ""
  echo "  1. Crear repo en GitHub:"
  echo "     https://github.com/new"
  echo "     - Owner: Meher1294"
  echo "     - Name: magnus-radar"
  echo "     - Private"
  echo "     - SIN README, gitignore ni license"
  echo "     - Click 'Create repository'"
  echo ""
  echo "  2. En esta terminal:"
  echo "     git push -u origin main"
  echo ""
  echo "  3. Activar GitHub Pages:"
  echo "     https://github.com/Meher1294/magnus-radar/settings/pages"
  echo "     - Source: GitHub Actions"
  echo "     - Save"
  echo ""
  echo "  4. Esperar ~2 min y abrir:"
  echo "     https://meher1294.github.io/magnus-radar/"
fi
