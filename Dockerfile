FROM node:17

WORKDIR /home/node/app

COPY package.json ./

RUN npm install

COPY . .


ENTRYPOINT ["npm"]
CMD ["start"]
# ENTRYPOINT ["/bin/bash", "-c"]