FROM nginx:alpine

# Copy the static files to the nginx default directory
COPY index.html /usr/share/nginx/html/index.html

# Copy a template for the nginx configuration
# We'll use the default config but replace the port at runtime
RUN printf 'server {\n\
    listen %s;\n\
    server_name localhost;\n\
    location / {\n\
        root /usr/share/nginx/html;\n\
        index index.html;\n\
    }\n\
}\n' '$PORT' > /etc/nginx/conf.d/default.conf.template

# Use a startup command to replace $PORT in the template and start nginx
CMD ["/bin/sh", "-c", "envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
