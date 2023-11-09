cd EANginxUwsgiBase
docker build -t earthadvantage/py-base:latest -t earthadvantage/py-base:v1.0.0 -t earthadvantage/py-base:node-1.18-20.04_edge .
cd ../EASSHBase
docker build -t earthadvantage/py-ssh-base:latest -t earthadvantage/py-ssh-base:v1.0.0 .