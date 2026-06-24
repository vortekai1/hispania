# DFM Lavaderos · Panel — build estático (despliegue)

Este repositorio contiene **únicamente el build de producción** del panel del asistente
telefónico de DFM Lavaderos (estáticos generados por Vite) más la configuración mínima
para servirlo con **nginx** en **Easypanel**.

> El código fuente vive aparte. Aquí solo se publica el resultado de `npm run build`.

## Contenido

```
.
├── index.html          ← entrada de la SPA
├── favicon.svg
├── assets/             ← JS/CSS con hash (cache inmutable)
├── Dockerfile          ← imagen nginx que sirve los estáticos
├── nginx.conf          ← fallback SPA + cache + cabeceras de seguridad
├── .dockerignore
└── .gitignore
```

## Desplegar en Easypanel

1. Sube esta carpeta a un repositorio de GitHub (ver comandos abajo).
2. En Easypanel: **Create Service → App**.
3. **Source**: el repositorio de GitHub (rama `main`).
4. **Build**: método **Dockerfile** (ruta `./Dockerfile`, se autodetecta).
5. **Deploy**. El contenedor expone el puerto **80**; asígnale un dominio
   (subdominio de Easypanel o de Cloudflare).
6. Cada `git push` a `main` puede redeplegar automáticamente si activas el auto-deploy.

## Subir a GitHub (desde la carpeta dist)

```bash
cd dist
git init -b main
git add .
git commit -m "deploy: panel DFM Lavaderos (build estático)"
git remote add origin git@github.com:<org>/<repo>.git
git push -u origin main
```

## Importante: variables de entorno (se hornean en el build)

Vite **inyecta las variables `VITE_*` en tiempo de build**, no en runtime. Este build
se generó en **modo demo** (`VITE_DATA_MODE=mock`): muestra datos de ejemplo y no
necesita backend.

Para pasar a **datos reales hay que regenerar el build** en el proyecto fuente con las
variables del modo live y volver a publicar esta carpeta.

### Modo live recomendado: Supabase

```bash
# en la carpeta del proyecto fuente (dashboard/)
VITE_DATA_MODE=supabase \
VITE_SUPABASE_URL=https://supabase.srv994140.hstgr.cloud \
VITE_SUPABASE_ANON_KEY=<anon key del VPS> \
npm run build
# luego subir el nuevo contenido de dist/ al repo
```

En modo supabase el acceso es por **email + password de Supabase Auth** (no por el password
de demo). Antes de publicar, completar los pasos de despliegue de `supabase/schema.sql`
(RLS + `GOTRUE_DISABLE_SIGNUP=true`).

### Alternativa: proxy n8n

```bash
VITE_DATA_MODE=n8n \
VITE_N8N_BASE=https://n8n.srv994140.hstgr.cloud/webhook \
VITE_DASH_TOKEN=<token> \
npm run build
```

> ⚠️ El password `lavaderos` es **solo de la demo** (modo mock/n8n). No es seguridad real
> y no aplica en modo supabase. No publiques el build `mock` como entregable "live".
