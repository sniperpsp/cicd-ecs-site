# Dockerfile
FROM node:14

# Diretório de trabalho
WORKDIR /usr/src/app

# Copiar arquivos
COPY package*.json ./
COPY . .

# Instalar dependências
RUN npm install

# Expor a porta
EXPOSE 8080

# Comando para iniciar a aplicação
CMD ["sh", "-c", "./update_dns.sh && npm start"]