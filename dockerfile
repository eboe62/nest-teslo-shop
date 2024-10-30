# Usa una imagen base oficial de Node.js (versión LTS)
FROM node:18-alpine

# Instala dependencias del sistema y curl
RUN apk update && apk add --no-cache git curl

# Crear directorio de trabajo y copiar package.json y package-lock.json
WORKDIR /app

# En cada build limpia el directorio de trabajo y clona el repositorio en él
RUN rm -rf /app/* && \
    git clone https://github.com/eboe62/nest-teslo-shop.git /app

# Copia solo los archivos de dependencias y los instala
COPY package*.json ./

# Instala las dependencias usando npm, incluyendo bcrypt y swagger y aplicar auditoría
# Después limpia la cache para reducir el tamaño de la imagen y actualizamos npm
RUN npm install --legacy-peer-deps && \ 
    npm install -g npm@latest && \
    npm cache clean --force

# Mostrar errores en el log
RUN cat /root/.npm/_logs/* || echo "No errors in log"

# Copia el resto de los archivos del proyecto
COPY . .

# Exponer el puerto en el que escucha la app
EXPOSE 3001

# Comando para iniciar la aplicación en modo desarrollo
CMD ["npm", "run", "start:dev"]