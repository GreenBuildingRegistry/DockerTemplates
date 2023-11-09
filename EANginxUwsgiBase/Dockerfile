# Final Docker config must copy and symlink app conf to sites-
# And start nginx from entrypoint: /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "pid /var/run/nginx.pid"
# and  must upload uwsgi (see EADjangoTemplate) and launch from entrypoint: /usr/local/bin/uwsgi --ini path_to_uwsgi.ini

FROM ubuntu/nginx:1.18-20.04_edge

RUN apt-get update \
    && apt-get install -y less python3-dev python3-pip uwsgi-core uwsgi-plugin-python3 supervisor \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts && chown www-data /var/log/supervisor

# NGINX
COPY nginx.conf /etc/nginx
RUN chmod 644 /etc/nginx/nginx.conf && chown www-data:www-data /var/lib/nginx \
    && mkdir /var/nginx && chown www-data:www-data /var/nginx && chown www-data /var/log/nginx \
    && rm /etc/nginx/sites-enabled/default \
    && pip install uwsgi populate-configs==0.0.5 --no-cache-dir && pip3 install --ignore-installed PyYAML\
    && touch /var/log/uwsgi.log && chmod 664 /var/log/uwsgi.log && chown www-data:www-data /var/log/uwsgi.log \
    && touch /var/www/touch-reload && chmod 664 /var/www/touch-reload && chown www-data:www-data /var/www/touch-reload
