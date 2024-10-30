# Usa una imagen base oficial de Node.js (versión LTS)
FROM node:18-alpine

# Instala dependencias del sistema y curl
RUN apk update && apk add --no-cache git curl

# Crear directorio de trabajo y copiar package.json y package-lock.json
WORKDIR /app

# Copia el archivo package.json y package-lock.json en el contenedor
COPY package*.json ./

# En cada build limpia el directorio de trabajo y clona el repositorio en él
RUN rm -rf /app/* && \
    git clone https://github.com/eboe62/nest-teslo-shop.git /app


# Instala las dependencias usando npm, incluyendo bcrypt y swagger y aplicar auditoría
# Después limpia la cache para reducir el tamaño de la imagen y actualizamos npm
RUN npm install --legacy-peer-deps && \ 
    npm install bcrypt @nestjs/swagger --legacy-peer-deps && \
    npm audit fix --force && \
    npm cache clean --force && \ 
    npm install -g npm@latest

# Copia el resto de los archivos del proyecto
COPY . .

# Exponer el puerto en el que escucha la app
EXPOSE 3001

# Comando para iniciar la aplicación en modo desarrollo
CMD ["npm", "run", "start:dev"]