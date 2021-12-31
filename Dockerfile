FROM node:17

WORKDIR /home/node/app

COPY package.json package-lock.json vite.config.js ./

RUN npm install

COPY . .

ENTRYPOINT ["npm"]
CMD ["start"]
EXPOSE 3000
