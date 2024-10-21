# Usa una imagen oficial de Node.js como base
FROM node:18-alpine

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia el archivo package.json y package-lock.json (si existe)
COPY package*.json ./

# Instala las dependencias de la aplicación
RUN npm install

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Expone el puerto que utiliza la aplicación (esto dependerá de tu configuración, en general es 3000)
EXPOSE 3000

# Define el comando por defecto para ejecutar la aplicación
CMD ["npm", "run", "start:dev"]
