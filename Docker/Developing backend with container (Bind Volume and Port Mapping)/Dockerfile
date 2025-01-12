FROM node

WORKDIR /apps

COPY *.json .

RUN npm install

COPY . .

ARG PORT=3000

ENV PORT=${PORT} 

EXPOSE ${PORT}

CMD [ "npm","run","dev" ]