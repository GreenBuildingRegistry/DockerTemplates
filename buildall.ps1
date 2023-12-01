cd py-uwsgi-nginx-base
docker build -t earthadvantage/py-uwsgi-nginx-base:latest -t earthadvantage/py-uwsgi-nginx-base:v1.0.0 .
cd ../py-uwsgi-nginx-ssh-base
docker build -t earthadvantage/py-uwsgi-nginx-ssh-base:latest -t earthadvantage/py-uwsgi-nginx-ssh-base:v1.0.0 .