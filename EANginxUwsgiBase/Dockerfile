FROM ubuntu/nginx

RUN apt-get update
RUN apt-get install -y python3-pip

# NGINX
COPY nginx.conf /etc/nginx
RUN chmod 644 /etc/nginx/nginx.conf
RUN pip install certbot certbot-nginx
# Final Docker config must copy and symlink app conf to sites- and run:
#        certbot --nginx --expand -m {email} --agree-tos -n
#                -d {server} # for each server name
#                --redirect
# And start nginx from entrypoint: /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "pid /var/run/nginx.pid"

# uWSGI
RUN apt-get install -y uwsgi-core uwsgi-plugin-python3
RUN pip install uwsgi
RUN touch /var/log/uwsgi.log
RUN chmod 664 /var/log/uwsgi.log
RUN chown www-data:www-data /var/log/uwsgi.log
RUN touch /var/www/touch-reload
RUN chmod 664 /var/www/touch-reload
RUN chown www-data:www-data /var/www/touch-reload
# Final Docker config must upload uwsgi (see EADjangoTemplate) and launch from entrypoint:
# /usr/local/bin/uwsgi --ini path_to_uwsgi.ini

RUN pip install populate-configs