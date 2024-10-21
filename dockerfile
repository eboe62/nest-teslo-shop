# Usa una imagen base de Node.js
FROM node:18-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo package.json y package-lock.json al contenedor
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos del proyecto al contenedor
COPY . .

# Exponer el puerto en el que escucha la app (el mismo que usa NestJS)
EXPOSE 3000

# Comando para correr la aplicación en modo desarrollo
CMD ["npm", "run", "start:dev"]
