## Official EA docker templates

* `earthadvantage/py-base` (formerly `ea-base`) => EANginxUwsgiBase
* `earthadvantage/py-ssh-base` (formerly `ea-ssh-base`) => EASSHBase
* EADjangoTemplates contains example Dockerfiles for how to run Django and Angular templates, independently and together, that we use for apps.

To build them:
1. Install PowerShell
2. in this directory run `pwsh buildall.ps1`