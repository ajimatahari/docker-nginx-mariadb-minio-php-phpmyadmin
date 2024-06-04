# Check if at least one domain is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 domain1 domain2 ... domainN"
    exit 1
fi

DOMAINS=("$@")

# Function to create Nginx server block configurations
create_nginx_config() {
    DOMAIN="$1"
    WEB_ROOT="/var/www/html/$DOMAIN"
    DOCKER_WEB_ROOT="./src/$DOMAIN"
    NGINX_CONFIG="./config/nginx/conf.d/${DOMAIN}.conf"

    # Create web root directory
    sudo mkdir -p $DOCKER_WEB_ROOT
    sudo chown -R $USER:$USER $DOCKER_WEB_ROOT
    sudo chmod -R 755 /var/www

    # Get current date and time in various formats
    current_date_time=$(date "+%Y-%m-%d %H:%M:%S")
    current_date=$(date "+%Y-%m-%d")
    current_time=$(date "+%H:%M:%S")
    human_readable=$(date "+%A, %B %d, %Y %I:%M:%S %p")

    # Create a simple PHP info page
    echo "${DOMAIN} Domain Project Created at ${human_readable}" > $DOCKER_WEB_ROOT/index.php

    # Create Nginx server block configuration
    sudo tee $NGINX_CONFIG > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $WEB_ROOT;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }

    # Basic DDoS protection
    # limit_req_zone \$binary_remote_addr zone=mylimit:10m rate=30r/m;
    # location / {
    #    limit_req zone=mylimit burst=10 nodelay;
    #    try_files \$uri \$uri/ =404;
    # }
}
EOF

}
    #  restart the docker to load the newconfiguration
    docker-compose down && docker-compose up -d

# Loop through each domain and create Nginx configurations
for DOMAIN in "${DOMAINS[@]}"; do
    create_nginx_config "$DOMAIN"
done

# Test Nginx configuration and reload
# sudo nginx -t && sudo systemctl reload nginx
