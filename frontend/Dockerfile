FROM node:current-alpine3.22 AS build

WORKDIR /app

COPY *.json ./
RUN npm ci

COPY . ./
RUN npm run build

FROM nginx:stable-alpine AS prod
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]