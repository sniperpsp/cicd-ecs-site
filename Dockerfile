FROM node:lts-slim
RUN mkdir /bot
WORKDIR /bot
COPY . /bot
RUN apt update -y
RUN apt install nano -y
RUN apt install curl -y
RUN apt install git -y
RUN npm install -g create-react-app
EXPOSE 3000
CMD ["sh", "-c", "npm install && npm start"]