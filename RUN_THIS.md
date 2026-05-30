# Magnus Radar — Setup en 4 pasos

Sigue estos pasos en orden. Todo está automatizado por `go.sh`.

---

## Paso 1 — Crear cuenta y proyecto Supabase (5 min · acción humana)

1. Ve a [supabase.com](https://supabase.com) → **Sign in with GitHub** (con tu cuenta `Meher1294`)
2. **New project**:
   - Nombre: `magnus-radar`
   - Región: `South America (São Paulo)`
   - Password DB: genera uno fuerte y guárdalo en 1Password
3. Espera 2 minutos a que aprovisione
4. **Dashboard → Settings → Database → Connection string → URI**:
   - Copia esa URL (empieza con `postgresql://postgres:[password]@db.xxxxxxxxx.supabase.co:5432/postgres`)
   - **Reemplaza `[password]` por tu password real**

---

## Paso 2 — Crear repo en GitHub (3 min · acción humana)

**Opción A** — Si tienes `gh` CLI (recomendado):

```bash
brew install gh        # si no lo tienes
gh auth login          # autentica con tu cuenta Meher1294
```

Después go.sh creará el repo automáticamente.

**Opción B** — Manual:

1. Ve a [github.com/new](https://github.com/new)
2. Owner: `Meher1294` · Name: `magnus-radar` · Private · **sin** README, .gitignore, ni license
3. Click "Create repository"

---

## Paso 3 — Editar .env (2 min · acción humana)

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
cp .env.example .env
nano .env       # o code .env
```

**Completa al menos estas 4 variables** (las demás pueden quedar como están por ahora):

```bash
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...                                  # de Settings → API → anon public
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...                          # de Settings → API → service_role
SUPABASE_DB_URL=postgresql://postgres:[pwd]@db.xxx.supabase.co:5432/postgres
```

---

## Paso 4 — Ejecutar `go.sh` (15 min · automático)

```bash
cd magnus-radar
bash go.sh
```

El script ejecutará las 3 fases una tras otra:

- **FASE 1 — Local**: git init, SSH key generada, commit, push a GitHub
- **FASE 2 — Supabase**: ejecuta migrations, carga 7.686 predios + 17 SEIA
- **FASE 3 — VPS**: SSH al `187.127.19.173`, deploya con `docker compose up`

Cada paso te pide confirmación con `[s/N]`. Si algo falla, te da el comando de troubleshooting exacto.

### Si solo quieres correr una fase:

```bash
bash go.sh check       # solo validar (no modifica nada)
bash go.sh local       # solo Mac + GitHub
bash go.sh supabase    # solo schema + seeds
bash go.sh vps         # solo deploy VPS
```

---

## Paso 5 — Validar (1 min)

```bash
bash validate.sh
```

Hace health-checks contra el VPS y la API. Si todo está verde, abre tu navegador en:

**https://187.127.19.173**

(acepta el cert self-signed por ahora — cuando agregues dominio `magnusradar.cl` será HTTPS válido)

---

## Bloqueador esperado en la primera corrida

**FASE 3 - VPS fallará la primera vez** porque tu SSH key todavía no está en el VPS. Cuando eso pase, sigue las instrucciones que te imprime el script:

1. Conéctate a la **consola web de Hostinger** (hPanel → VPS → Browser SSH) como root
2. Corre el bootstrap (asume que el repo ya está pusheado a GitHub):

```bash
curl -fsSL https://raw.githubusercontent.com/Meher1294/magnus-radar/main/deploy/bootstrap_vps.sh | bash
```

3. Pega tu SSH public key en el VPS (el comando exacto te lo imprime go.sh):

```bash
echo 'ssh-ed25519 AAAA... max@xpu.cl' >> /home/magnus/.ssh/authorized_keys
```

4. Vuelve a tu Mac y corre:

```bash
bash go.sh vps
```

Esta vez SSH funcionará y deployará el stack.

---

## Después del deploy

| Acción | Comando |
|---|---|
| Re-deploy tras cambios | `git push origin main` (GitHub Actions hace el resto) |
| Ver logs del API | `ssh magnus@187.127.19.173 'cd /opt/magnus-radar && docker compose logs -f api'` |
| Restart contenedores | `ssh magnus@187.127.19.173 'cd /opt/magnus-radar && docker compose restart'` |
| Re-cargar seeds | `bash go.sh supabase` |
| Validar health | `bash validate.sh` |

---

## Tiempos esperados

| Fase | Manual | Automático |
|---|---|---|
| 1. Supabase setup | 5 min | — |
| 2. GitHub repo | 3 min | — |
| 3. Edit .env | 2 min | — |
| 4. `bash go.sh` primera corrida | — | 8 min (falla en VPS) |
| 5. Bootstrap VPS | 5 min | — |
| 6. `bash go.sh vps` segunda corrida | — | 5 min |
| 7. `bash validate.sh` | — | 30 seg |
| **TOTAL** | **15 min** | **15 min** |

**~30 minutos hasta producción accesible públicamente.**
