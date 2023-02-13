#!/usr/bin/env bash
# TODO: Add handling to better manage services. IE: gracefully quit, monitor for failures and restart, etc.

# Apply Django Migrations
cd /var/www/'{app name and/or path to backend}'
python3 manage.py migrate --settings='{dot notation path to settings}'

# Restart Redis/RQWorker
/usr/local/bin/redis-server /etc/redis/redis.conf
python3 manage.py rqworker high default low

# Restart NGINX
/usr/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
# TODO: see certbot question in Dockerfile and command in EANginxUwsgiBase/Dockerfile
/usr/sbin/nginx -c /etc/nginx/nginx.conf -g 'daemon on; master_process on;'

# Restart uWSGI
/usr/local/bin/uwsgi --ini path_to_uwsgi.ini