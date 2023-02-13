# The files in this directory should be copied to the app root
# and edited with any non-secret values as appropriate
# and/or the command for populate-configs added to appropriately update templates
# This template assumes rqworker via Redis and SSMTP for outgoing emails

# TODO: Need to solve for getting the config params file into the container

FROM ea-redis-smtp-base

# TODO: Any additional apt installs, such as those needed for GEODjango/PostGIS

# NGINX
COPY '{app nginx conf}' /etc/nginx/sites-available
RUN chmod 644 /etc/nginx/sites-available/'{app nginx conf}'
RUN ln -s /etc/nginx/sites-available/'{app nginx conf}' /etc/nginx/sites-enabled/'{app nginx conf}'
# TODO: Can certbot be run here? Or does it have to wait until it is in lightsail and has the domain name attached?

# uWSGI
COPY vassal.ini /etc/uwsgi/vassals
RUN chmod 644 /etc/uwsgi/vassals/vassal.ini

# Redis
RUN chmod 644 /lib/systemd/system/rqworker.service
RUN populate-configs -y '{location deploy params yaml}' -f /etc/redis/redis.conf

# SMTP
RUN populate-configs -y '{location deploy params yaml}' -f /etc/ssmtp/ssmtp.conf

# APP
WORKDIR /var/www/
COPY '{app path}' ./
RUN pip install --no-cache-dir -r '{path to requirements file}'

WORKDIR /var/www/'{app name and/or path to backend}'
RUN populate-configs -y '{location deploy params yaml}' f '{location of production.py}'
# TODO: Repeat above for any other Jinja2 template configs (config.yaml, etc)
RUN python3 manage.py collectstatic --noinput --settings='{dot notation path to settings}'

CMD ["startup.sh"]
