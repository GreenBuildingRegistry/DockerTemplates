# This file, along with the relevant files in the parent directory should be copied to the app root
# and edited with any non-secret values as appropriate
# and/or the command for populate-configs added to appropriately update templates
# This template assumes rqworker with Redis running on an separate container and SSMTP for outgoing emails.
# Remove lines 46 to 48 as appropriate, and edit the supervisor conf, if these services are not needed.
# NOTE: For reasons I have yet to discover, a copy of Django's wsgi.py must exist in the same directory as manage.py

ARG APP_ENV

FROM node:16 as build-env
WORKDIR /app
RUN apt-get update && apt-get -y upgrade npm python3-dev python3-pip \
        && pip3 install populate-configs --no-cache-dir

COPY ./frontend ./

# TODO: Watch out for any secrets that should not be committed to the repo via the .yaml file
COPY '{config file}'.yaml ./

RUN npm install -g @angular/cli@'{Desired Angular version}' && npm install \
    && ng build vendors  \
    # && all other projects libraries
    && populate-configs -y '{full path to config file}' -f '{path to environment.prod.ts}' -s $APP_ENV \
    && ng build app-gui --configuration  production


FROM ea-base
ARG APP_ENV
WORKDIR /var/www/'{app path}'

# TODO: Any additional apt installs, such as those needed for GEODjango/PostGIS
#RUN apt-get update && apt-get -y upgrade libmagic-dev \
#    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts \

COPY docker ./

RUN mkdir -p /etc/uwsgi/vassals && mv '{app nginx conf}' /etc/nginx/sites-available \
    && chmod 644 /etc/nginx/sites-available/'{app nginx conf}' \
    && ln -s /etc/nginx/sites-available/'{app nginx conf}' /etc/nginx/sites-enabled/'{app nginx conf}' \
    && mv emperor.ini /etc/uwsgi/emperor.ini \
    && mv vassal.ini /etc/uwsgi/vassals \
    && chmod 644 /etc/uwsgi/vassals/vassal.ini \
    && mv supervisor.conf /etc/supervisor/conf.d/ \
    && chmod 644 /etc/supervisor/conf.d/supervisor.conf \
    && chown www-data /var/www/'{app path}' \
    && mv /tmp/ssmtp.conf /etc/ssmtp && chmod 640 /etc/ssmtp/ssmtp.conf \
    && mkdir /var/log/rq && chown www-data:www-data /var/log/rq \
    && populate-configs -y '{full path to config file}'.yaml -f /etc/ssmtp/ssmtp.conf -s $APP_ENV \
    && populate-configs -y '{full path to config file}'.yaml -f /etc/nginx/sites-available/'{app nginx conf}' -s $APP_ENV \
    && rm '{full path to config file}'.yaml


# APP
COPY '{backend app path}' ./backend
WORKDIR /var/www/'{app name and/or backend path}'
RUN pip install --no-cache-dir -r '{path to requirements file}'

WORKDIR /var/www/'{app name}'
COPY --from=build-env /app/dist/'{Angular app name}' ./gui

# HTML port
EXPOSE 5000
# SSH port
EXPOSE 3232

USER www-data
CMD ["{full path to}/startup.sh"]


