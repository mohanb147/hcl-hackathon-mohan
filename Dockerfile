FROM node:20-alpine
WORKDIR /usr/src/app
COPY patient-service.js ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]