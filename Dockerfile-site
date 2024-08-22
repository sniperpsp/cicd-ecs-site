# Use a imagem oficial do Node.js como a base
FROM node:14

# Defina o diretório de trabalho
WORKDIR /usr/src/app

# Copie o package.json e o package-lock.json
COPY package*.json ./

RUN npm config set strict-ssl false


# Instale as dependências
RUN npm install

# Copie o restante do código da aplicação
COPY . .

# Exponha a porta da aplicação
EXPOSE 3000

# Comando para rodar a aplicação
CMD ["node", "index.js"]
