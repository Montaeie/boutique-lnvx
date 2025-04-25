FROM node:16-alpine

WORKDIR /app

COPY boutique-lnvx-storefront/package*.json ./

RUN npm ci

COPY boutique-lnvx-storefront/ .

RUN npm run build

EXPOSE 8000

CMD ["npm", "run", "start"]
