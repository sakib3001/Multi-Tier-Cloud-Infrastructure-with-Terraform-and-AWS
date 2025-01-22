#!/bin/bash
# Update the package repository
apt-get update -y

# Install Nginx
apt-get install -y nginx

# Create an HTML file with the desired content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web Server</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
        }
        h1 {
            font-size: 5rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>web-server</h1>
</body>
</html>
EOF

# Ensure Nginx is started and enabled
systemctl start nginx
systemctl enable nginx
