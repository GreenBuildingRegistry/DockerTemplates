# The files in this directory should be copied to the app root
# and edited with any non-secret values as appropriate
# and/or the command for populate-configs added to appropriately update templates
# This template assumes rqworker via Redis and SSMTP for outgoing emails

ARG APP_ENV

FROM ea-redis-smtp-base

# TODO: Any additional apt installs, such as those needed for GEODjango/PostGIS
# RUN apt-get update && apt-get install -y <apt packages> && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# TODO: I will figure out how to deal with it as ENV variables at a later date
WORKDIR /var/www/
COPY '{config file}'.yaml '{app nginx conf}' emperor.ini vassal.ini  ./
RUN mv '{app nginx conf}'/etc/nginx/sites-available \
    && chmod 644 /etc/nginx/sites-available/'{app nginx conf}' \
    && ln -s /etc/nginx/sites-available/freddie_nginx /etc/nginx/sites-enabled/'{app nginx conf}' \
    && mv emperor.ini /etc/uwsgi/emperor.ini \
    && mv vassal.ini /etc/uwsgi/vassals \
    && chmod 644 /etc/uwsgi/vassals/vassal.ini

# Redis
# TODO: the rqworker.service is wrong. I am missing a step towards getting rqworker installed and running I think
#RUN chmod 644 /lib/systemd/system/rqworker.service

RUN populate-configs -y '{config file}'.yaml -f /etc/redis/redis.conf -s sandbox \
    && populate-configs -y '{config file}'.yaml -f /etc/ssmtp/ssmtp.conf -s sandbox \
    # && populate-configs -y '{config file}'.yaml f '/etc/nginx/sites-available/{app nginx conf}'

# APP
WORKDIR /var/www/'{app name}'
COPY '{backend app path}' ./backend
RUN pip install --no-cache-dir -r '{path to requirements file}'

WORKDIR /var/www/'{app name}'/backend
RUN populate-configs -y '{location deploy params yaml}' f '{location of production.py}' \
    && python3 manage.py collectstatic --noinput --settings='{dot notation path to settings}'
# TODO: Repeat above for any other Jinja2 template configs (config.yaml, etc)

RUN rm /var/www/'{config file}'.yaml
USER www-data
CMD ["startup.sh"]
