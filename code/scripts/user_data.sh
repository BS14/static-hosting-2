#!/bin/bash
# 1. Install/Update Nginx
apt-get update -y && apt-get install -y nginx

# 2. Setup standard Nginx config
cat <<EOF >/etc/nginx/sites-available/default
server {
    listen 80 default_server;
    root /var/www/html;
    index index.html;

    location /health {
        access_log off;
        return 200 'OK';
    }

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# 3. Inject App Content (The GHA will replace this placeholder)
cat <<'EOC' >/var/www/html/index.html
{{CONTENT}}
EOC

# 4. Restart services
systemctl restart nginx
systemctl enable nginx
