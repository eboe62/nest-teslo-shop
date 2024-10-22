# Usa una imagen base de PostgreSQL
FROM postgres:14.3

# Actualiza el sistema e instala nano y watch, luego limpia el caché de apt
RUN apt-get update && apt-get install -y nano watch && rm -rf /var/lib/apt/lists/*

# Copia el archivo postgresql.conf desde la carpeta del host (máquina Windows) al contenedor
COPY ./postgresql.conf /var/lib/postgresql/data/postgresql.conf

# Cambia el dueño del archivo postgresql.conf a postgres
RUN chown postgres:postgres /var/lib/postgresql/data/postgresql.conf

# Configurar las variables de entorno de PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=999999999
ENV POSTGRES_DB=TesloDB

# Exponer el puerto 5432 para acceder a PostgreSQL
EXPOSE 5432

# Personalizar el prompt de Bash con colores dinámicos:
# Verde claro (1;32) para éxito, Naranja (38;5;214) para error
RUN echo 'PROMPT_COMMAND='\''PS1="\[\033[0;33m\][\!]\`if [[ \$? = \"0\" ]]; then echo \"\[\033[1;32m\]\"; else echo \"\[\033[38;5;214m\]\"; fi\`[\u@\h: \`if [[ `pwd | wc -c | tr -d \" \"` > 18 ]]; then echo \"\\W\"; else echo \"\\w\"; fi\`]\$ \[\033[0m\]"; echo -ne "\033]0;`hostname -s`:`pwd`\007"'\'' ' >> /root/.bashrc

# Aplica el mismo prompt dinámico para el usuario postgres
RUN echo 'PROMPT_COMMAND='\''PS1="\[\033[0;33m\][\!]\`if [[ \$? = \"0\" ]]; then echo \"\[\033[1;32m\]\"; else echo \"\[\033[38;5;214m\]\"; fi\`[\u@\h: \`if [[ `pwd | wc -c | tr -d \" \"` > 18 ]]; then echo \"\\W\"; else echo \"\\w\"; fi\`]\$ \[\033[0m\]"; echo -ne "\033]0;`hostname -s`:`pwd`\007"'\'' ' >> /var/lib/postgresql/.bashrc

# Configurar el prompt de PostgreSQL en amarillo siempre
RUN echo '\set PROMPT1 "%[%033[0;33m%]%n@%/%[%033[0m%]%# "' >> /root/.psqlrc
RUN echo '\set PROMPT2 "%[%033[0;33m%]-%[%033[0m%] "' >> /root/.psqlrc

# Aplica el mismo prompt de PostgreSQL en amarillo para el usuario postgres
RUN echo '\set PROMPT1 "%[%033[0;33m%]%n@%/%[%033[0m%]%# "' >> /var/lib/postgresql/.psqlrc
RUN echo '\set PROMPT2 "%[%033[0;33m%]-%[%033[0m%] "' >> /var/lib/postgresql/.psqlrc

# Define el comando por defecto para ejecutar el contenedor
CMD ["docker-entrypoint.sh", "postgres"]
