#!/bin/sh
# Replace variables inside nginx template
envsubst '${BACKEND_URL}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"
