# Устанавливаем базовый образ
FROM node:16-alpine as build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы
COPY . .

# Создаем сборку
RUN npm run build

# Используем nginx для сервировки приложения
FROM nginx:alpine

# Копируем созданные файлы из предыдущего образа
COPY --from=build /app/dist /usr/share/nginx/html

# Копируем файл конфигурации nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
