# Imagen estatica para Easypanel: sirve el build de Vite (estaticos) con nginx.
# El contexto de build es la propia carpeta dist/ (que es lo que se sube a GitHub).
FROM nginx:1.27-alpine

# Copiamos SOLO los estaticos servibles (no los ficheros de infraestructura).
COPY index.html /usr/share/nginx/html/index.html
COPY favicon.svg /usr/share/nginx/html/favicon.svg
COPY assets /usr/share/nginx/html/assets

# Configuracion de nginx: fallback SPA (react-router) + cache + cabeceras.
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# La imagen base de nginx ya arranca en foreground; no hace falta CMD.
