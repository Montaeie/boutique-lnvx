FROM node:16-alpine

WORKDIR /app

COPY boutique-lnvx/package*.json ./

RUN npm ci

COPY boutique-lnvx/ .

RUN npm run build

EXPOSE 9000

CMD ["npm", "run", "start"]
