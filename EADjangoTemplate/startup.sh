#!/usr/bin/env bash
# TODO: Add handling to better manage services. IE: gracefully quit, monitor for failures and restart, etc.

# Apply Django Migrations
cd /var/www/'{app name and/or path to backend}'
python3 manage.py migrate --settings='{dot notation path to settings}'

# Start Supervisor
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf