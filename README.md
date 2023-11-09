## Official EA docker templates

### Contents:
* `earthadvantage/py-uwsgi-nginx-base` (formerly `EANginxUwsgiBase`)
* `earthadvantage/py-uwsgi-nginx-ssh-base` (formerly `EASSHBase`)
* These are automatically built and pushed to dockerhub when merged into the dev branch.
* Templates contains example Dockerfiles for how to run Django and Angular templates, independently and together, that we use for apps.

To build them locally (although you shouldn't do that):
1. Install PowerShell
2. in this directory run `pwsh buildall.ps1`

### py-uwsgi-nginx-base
A default docker container that setups uwsgi and nginx for python app deployment.

### py-uwsgi-nginx-ssh-base
A default docker container that adds on `py-uwsgi-nginx-base` by adding SSH for development/Testing. Apps should not be deployed using this as prod apps shouldn't have SSH turned on by default.