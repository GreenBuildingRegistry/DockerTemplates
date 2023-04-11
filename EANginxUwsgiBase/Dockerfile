FROM ubuntu/nginx

RUN apt-get update && apt-get install -y less python3-dev python3-pip uwsgi-core uwsgi-plugin-python3 && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# NGINX
COPY nginx.conf /etc/nginx
RUN chmod 644 /etc/nginx/nginx.conf
# Final Docker config must copy and symlink app conf to sites-
# And start nginx from entrypoint: /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "pid /var/run/nginx.pid"

# uWSGI
RUN pip install uwsgi populate-configs==0.0.5 --no-cache-dir
RUN touch /var/log/uwsgi.log && chmod 664 /var/log/uwsgi.log && chown www-data:www-data /var/log/uwsgi.log
RUN touch /var/www/touch-reload && chmod 664 /var/www/touch-reload && chown www-data:www-data /var/www/touch-reload
# Final Docker config must upload uwsgi (see EADjangoTemplate) and launch from entrypoint:
# /usr/local/bin/uwsgi --ini path_to_uwsgi.ini
