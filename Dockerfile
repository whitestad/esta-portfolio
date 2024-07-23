# Установка окружения для сборки
FROM node:16 AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN npm run build

# Установка окружения для сервера
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

# Удаление стандартной конфигурации nginx
RUN rm /etc/nginx/conf.d/default.conf

# Копирование нашей конфигурации nginx
COPY nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
