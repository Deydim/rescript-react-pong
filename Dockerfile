FROM node:15.12.0

# USER node

# RUN mkdir -p /app

WORKDIR /app

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# COPY ./package.json .

COPY . .
RUN chown -R node .
RUN npm install
# ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]

