const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  let html = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Awesome GitOps App</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f0f2f5; color: #333; margin: 0; padding: 20px; text-align: center; }
            .container { background-color: #fff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); padding: 30px; max-width: 600px; margin: 40px auto; }
            h1 { color: #007bff; margin-bottom: 20px; }
            pre { background-color: #e9ecef; padding: 15px; border-radius: 5px; text-align: left; overflow-x: auto; }
            .footer { margin-top: 30px; font-size: 0.9em; color: #6c757d; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Chào mừng đến với Ứng dụng GitOps của tôi!</h1>
            <p>Đây là các biến môi trường được inject từ Kubernetes ConfigMap:</p>
            <pre>${JSON.stringify(process.env, null, 2)}</pre>
            <div class="footer">
                <p>Được triển khai tự động bởi Argo CD trên K3s!</p>
            </div>
        </div>
    </body>
    </html>
  `;
  res.send(html);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
