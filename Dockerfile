# Sử dụng base image Node.js
FROM node:18-alpine

# Tạo thư mục làm việc
WORKDIR /app

# Copy package.json và package-lock.json (nếu có)
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Copy toàn bộ code ứng dụng
COPY . .

# Mở cổng mà ứng dụng lắng nghe
EXPOSE 8080

# Chạy ứng dụng khi container khởi động
CMD ["node", "index.js"]
