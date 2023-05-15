# This template is for an Angular only release. (the backend API runs on a separate server from the front end)
# The nginx.conf file from EANginxUwsgiBase and the angular_nginx file from the docker folder should be
# copied to a "docker" directory in the app root, where the Dockerfile, .dockerignore, and deploy.ps1 should also be copied.
# Also copy and modify the config_params.yaml.example file into the new "docker" directory, and modify, if needed.
# If no additional config params are needed, remove lines 17 and 22

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


FROM ubuntu/nginx:1.18-20.04_edge

COPY docker ./

RUN chmod 644 /etc/nginx/nginx.conf && chown www-data:www-data /var/lib/nginx \
    && mkdir /var/nginx && chown www-data:www-data /var/nginx && chown www-data /var/log/nginx \
    && rm /etc/nginx/sites-enabled/default \
    && mv '{app nginx conf}' /etc/nginx/sites-available \
    && chmod 644 /etc/nginx/sites-available/'{app nginx conf}' \
    && ln -s /etc/nginx/sites-available/'{app nginx conf}' /etc/nginx/sites-enabled/'{app nginx conf}' \

WORKDIR /var/www/'{app name}'
COPY --from=build-env /app/dist/'{Angular app name}' ./gui
EXPOSE 5000
USER www-data
CMD ["{full path to}/startup.sh"]