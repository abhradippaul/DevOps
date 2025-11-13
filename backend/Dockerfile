FROM node:current-alpine3.22 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:current-alpine3.22 AS prod

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8000

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

RUN npm ci --omit=dev

COPY --from=builder /app/.env ./

EXPOSE $PORT

CMD [ "npm" , "start" ]