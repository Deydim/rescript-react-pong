FROM node:15.12.0

WORKDIR /app

COPY . .

RUN chown -R node .

RUN npm install

CMD ["npm", "start"]

