FROM node:14

# Set working directory
WORKDIR /var/www/html

# Install PM2 to manage Node.js applications
RUN npm install -g pm2

# Expose port 3000 (or any other port your Node.js app uses)
# EXPOSE 3000
