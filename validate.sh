#!/usr/bin/env bash
# Magnus Radar — Validador post-deploy (no modifica nada)
# Uso: bash validate.sh

set -uo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $*"; }
fail() { echo -e "${RED}✗${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
say()  { echo -e "${BLUE}▸${NC} $*"; }

ERRORS=0

say "VPS conectividad..."
if ping -c 1 -W 2 187.127.19.173 >/dev/null 2>&1; then ok "VPS responde a ping"; else fail "VPS no responde ping"; ((ERRORS++)); fi

say "SSH al VPS..."
SSH_KEY="${HOME}/.ssh/magnus_radar"
if [ -f "$SSH_KEY" ] && ssh -i "$SSH_KEY" -o BatchMode=yes -o ConnectTimeout=5 magnus@187.127.19.173 "echo ok" 2>/dev/null | grep -q ok; then
  ok "SSH key funciona"
else
  fail "SSH no funciona. Verifica key en /home/magnus/.ssh/authorized_keys"; ((ERRORS++))
fi

say "Docker en VPS..."
ssh -i "$SSH_KEY" magnus@187.127.19.173 "docker compose -f /opt/magnus-radar/docker-compose.yml ps 2>/dev/null" || warn "compose no levantado"

say "API /health..."
if curl -kfs https://187.127.19.173/api/health -o /dev/null; then
  ok "API responde"
else
  fail "API no responde"; ((ERRORS++))
fi

say "API /api/comunas..."
COMUNAS=$(curl -kfs https://187.127.19.173/api/comunas 2>/dev/null)
if echo "$COMUNAS" | grep -q "La Higuera"; then
  ok "API devuelve La Higuera"
else
  fail "API no devuelve comunas correctamente"; ((ERRORS++))
fi

say "API /api/predios..."
N_PREDIOS=$(curl -kfs "https://187.127.19.173/api/predios?comuna=4102&limit=10" 2>/dev/null | python3 -c "import sys,json;print(len(json.load(sys.stdin)))" 2>/dev/null)
if [ "${N_PREDIOS:-0}" -gt 0 ]; then
  ok "API devuelve $N_PREDIOS predios (muestra)"
else
  fail "API no devuelve predios"; ((ERRORS++))
fi

say "Frontend HTML..."
if curl -kfs https://187.127.19.173/ | grep -q "Magnus Radar"; then
  ok "Frontend sirve HTML"
else
  fail "Frontend no responde"; ((ERRORS++))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}═══ TODO OK · Magnus Radar operativo en https://187.127.19.173 ═══${NC}"
else
  echo -e "${RED}═══ $ERRORS errores · revisar logs ═══${NC}"
  echo "Comandos útiles:"
  echo "  ssh -i $SSH_KEY magnus@187.127.19.173 'cd /opt/magnus-radar && docker compose logs --tail=50'"
  echo "  ssh -i $SSH_KEY magnus@187.127.19.173 'cd /opt/magnus-radar && docker compose ps'"
fi
