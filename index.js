const express = require('express');

// Load environment variables from .env file for local development
// In production (Kubernetes), variables come from ConfigMap
require('dotenv').config();

const app = express();
const port = process.env.PORT || 8080; // Can be configured via environment

// Get environment variables from ConfigMap (K8s) or .env file (local)
const message = process.env.MY_MESSAGE || "No message found!";
const otherVar = process.env.ANOTHER_VAR || "No other variable found.";

// Environment detection
const environment = process.env.NODE_ENV || 'development';
const isKubernetes = process.env.KUBERNETES_SERVICE_HOST ? true : false;

app.get('/', (req, res) => {
  // Create beautiful Welcome HTML page
  let html = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>🚀 Welcome to GitOps Project</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #333;
            }
            
            .welcome-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                padding: 50px;
                max-width: 700px;
                width: 90%;
                text-align: center;
                animation: slideUp 0.8s ease-out;
            }
            
            @keyframes slideUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .logo {
                font-size: 4rem;
                margin-bottom: 20px;
                animation: bounce 2s infinite;
            }
            
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                40% { transform: translateY(-10px); }
                60% { transform: translateY(-5px); }
            }
            
            h1 {
                font-size: 2.5rem;
                color: #2c3e50;
                margin-bottom: 15px;
                font-weight: 700;
            }
            
            .subtitle {
                font-size: 1.2rem;
                color: #7f8c8d;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            
            .status-card {
                background: linear-gradient(135deg, #6c5ce7, #a29bfe);
                color: white;
                padding: 25px;
                border-radius: 15px;
                margin: 25px 0;
                box-shadow: 0 10px 20px rgba(108, 92, 231, 0.3);
            }
            
            .status-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }
            
            .config-info {
                background: rgba(255, 255, 255, 0.2);
                border-radius: 10px;
                padding: 15px;
                margin-top: 15px;
                text-align: left;
            }
            
            .config-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 8px 0;
                padding: 8px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 5px;
                font-family: 'Courier New', monospace;
            }
            
            .config-key {
                font-weight: 600;
                color: #fdcb6e;
            }
            
            .config-value {
                color: #fff;
                font-style: italic;
            }
            
            .features {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-top: 30px;
            }
            
            .feature-card {
                background: linear-gradient(135deg, #00b894, #00cec9);
                color: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0, 184, 148, 0.3);
                transition: transform 0.3s ease;
            }
            
            .feature-card:hover {
                transform: translateY(-5px);
            }
            
            .feature-icon {
                font-size: 2rem;
                margin-bottom: 10px;
            }
            
            .feature-title {
                font-weight: 600;
                margin-bottom: 5px;
            }
            
            .footer {
                margin-top: 30px;
                padding-top: 20px;
                border-top: 2px dashed #ddd;
                color: #7f8c8d;
                font-size: 0.9rem;
            }
            
            .timestamp {
                background: #f8f9fa;
                padding: 10px;
                border-radius: 8px;
                border-left: 4px solid #6c5ce7;
                margin-top: 15px;
                font-family: 'Courier New', monospace;
                color: #2d3436;
            }
            
            @media (max-width: 768px) {
                .welcome-container { padding: 30px 20px; }
                h1 { font-size: 2rem; }
                .logo { font-size: 3rem; }
                .features { grid-template-columns: 1fr; }
            }
        </style>
    </head>
    <body>
        <div class="welcome-container">
            <div class="logo">🚀</div>
            <h1>Welcome to GitOps Project!</h1>
            <p class="subtitle">Application successfully deployed with automated CI/CD pipeline</p>
            
            <div class="status-card">
                <div class="status-title">
                    <span>✅</span>
                    <span>Deployment Status: SUCCESS</span>
                </div>
                <div class="config-info">
                    <div class="config-item">
                        <span class="config-key">Environment:</span>
                        <span class="config-value">${isKubernetes ? 'Kubernetes' : 'Local Development'}</span>
                    </div>
                    <div class="config-item">
                        <span class="config-key">MY_MESSAGE:</span>
                        <span class="config-value">"${message}"</span>
                    </div>
                    <div class="config-item">
                        <span class="config-key">ANOTHER_VAR:</span>
                        <span class="config-value">"${otherVar}"</span>
                    </div>
                    <div class="config-item">
                        <span class="config-key">Port:</span>
                        <span class="config-value">${port}</span>
                    </div>
                </div>
            </div>
            
            <div class="features">
                <div class="feature-card">
                    <div class="feature-icon">🐳</div>
                    <div class="feature-title">Docker</div>
                    <div>Containerized Application</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <div class="feature-title">GitHub Actions</div>
                    <div>Automated CI/CD Pipeline</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">☸️</div>
                    <div class="feature-title">Kubernetes</div>
                    <div>Container Orchestration</div>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🔄</div>
                    <div class="feature-title">Argo CD</div>
                    <div>GitOps Deployment</div>
                </div>
            </div>
            
            <div class="timestamp">
                <strong>🕐 Deploy Time:</strong> ${new Date().toLocaleString('en-US', { timeZone: 'UTC' })} UTC
            </div>
            
            <div class="footer">
                <p>🎉 <strong>Congratulations!</strong> You have successfully set up GitOps workflow</p>
                <p>📚 Repository: <strong>datpham-qualgo/my-first-gitops</strong></p>
            </div>
        </div>
    </body>
    </html>
  `;
  res.send(html);
});

app.listen(port, () => {
  console.log(`🚀 Application is listening on port ${port}`);
  console.log(`📍 Environment: ${isKubernetes ? 'Kubernetes' : 'Local Development'}`);
  console.log(`📝 MY_MESSAGE: ${message}`);
  console.log(`📝 ANOTHER_VAR: ${otherVar}`);
});
