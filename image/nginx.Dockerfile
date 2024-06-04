FROM nginx:latest

# Create web root directory
RUN mkdir -p /var/www/html

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80
