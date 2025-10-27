# 1. Dùng base image Node.js 18 (bản Alpine siêu nhẹ)
FROM node:18-alpine

# 2. Tạo thư mục làm việc trong container
WORKDIR /app

# 3. Copy package.json ĐỂ build cache hiệu quả
COPY package*.json ./

# 4. Cài đặt các gói phụ thuộc
RUN npm install

# 5. Copy toàn bộ code (index.js) vào
COPY . .

# 6. Mở cổng 8080 mà app đang chạy
EXPOSE 8080

# 7. Lệnh để chạy ứng dụng
CMD ["node", "index.js"]
