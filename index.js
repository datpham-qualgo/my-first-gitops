const express = require('express');
const app = express();
const port = 8080; // Phải khớp với Dockerfile và Deployment

// Lấy biến môi trường từ ConfigMap
const message = process.env.MY_MESSAGE || "Không tìm thấy thông điệp!";
const otherVar = process.env.ANOTHER_VAR || "Không có biến khác.";

app.get('/', (req, res) => {
  // Tạo một trang HTML đơn giản
  let html = `
    <!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang Web GitOps</title>
        <style>
            body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; display: grid; place-items: center; min-height: 90vh; background-color: #f4f7f6; }
            .container { background-color: #ffffff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.1); padding: 40px; max-width: 600px; text-align: center; }
            h1 { color: #2c3e50; }
            .message-box { background-color: #e8f4fd; border: 1px solid #b8dcfd; border-radius: 8px; padding: 20px; margin-top: 20px; text-align: left; }
            p { font-size: 1.1em; line-height: 1.6; }
            code { background-color: #dfe6e9; padding: 3px 6px; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🎉 Chào mừng đến với K3s & Argo CD! 🎉</h1>
            <p>Ứng dụng này được deploy tự động 100% bằng GitOps.</p>
            <div class="message-box">
                <p>Thông điệp từ <code>ConfigMap</code>:</p>
                <h3>${message}</h3>
                <p><code>ANOTHER_VAR</code>: ${otherVar}</p>
            </div>
        </div>
    </body>
    </html>
  `;
  res.send(html);
});

app.listen(port, () => {
  console.log(`Ứng dụng đang lắng nghe trên cổng ${port}`);
});
