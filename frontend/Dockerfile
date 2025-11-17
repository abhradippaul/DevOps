FROM node:current-alpine3.22 AS build

WORKDIR /app

COPY *.json ./
RUN npm ci

COPY . ./
RUN npm run build

FROM nginx:stable-alpine AS prod

EXPOSE 80
COPY --from=build /app/dist /usr/share/nginx/html
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]