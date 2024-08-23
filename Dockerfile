# Dockerfile
FROM node:14

# Diretório de trabalho
WORKDIR /usr/src/app

# Copiar arquivos
COPY package*.json ./
COPY . .

# Instalar dependências
RUN npm install

# Adicionar o script de atualização de DNS
COPY update_dns.sh /usr/src/app/update_dns.sh
RUN chmod +x /usr/src/app/update_dns.sh

# Expor a porta
EXPOSE 8080

# Comando para iniciar a aplicação
CMD ["sh", "-c", "./update_dns.sh && npm start"]