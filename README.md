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

Para cambiar el modo (p. ej. pasar a datos reales vía proxy n8n) o el password de
acceso, **hay que regenerar el build** en el proyecto fuente con las variables y volver
a publicar esta carpeta:

```bash
# en la carpeta del proyecto fuente (dashboard/)
VITE_DATA_MODE=n8n \
VITE_N8N_BASE=https://n8n.srv994140.hstgr.cloud/webhook \
VITE_DASH_TOKEN=<token> \
VITE_DASH_PASSWORD=<password> \
npm run build
# luego subir el nuevo contenido de dist/ al repo
```

Password del panel por defecto en este build: **`lavaderos`** (cámbialo regenerando
con `VITE_DASH_PASSWORD`).
