FROM node:10.23.0-alpine

WORKDIR apps

COPY . .

RUN npm install

RUN npm install sequelize-cli -g

RUN npm install pm2 -g

RUN npx sequelize db:migrate

EXPOSE 5000

CMD ["pm2-runtime", "server.js"]
