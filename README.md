# Ansible Homelab Deployment

This project contains Ansible playbooks and configurations for deploying a variety of services in a homelab environment. The services are deployed as Podman containers, and the deployment is managed by Ansible.

## Services

The following services are deployed by this project:

*   **Auth**: An authentication service based on Authentik.
*   **Backup**: A backup service based on Borgmatic.
*   **CentralDB**: A central database service that provides PostgreSQL, InfluxDB, and MongoDB.
*   **it-tools**: A collection of useful online tools for developers.
*   **Matterbridge**: A bridge between a variety of chat protocols.
*   **n8n**: A workflow automation tool.
*   **OpenWebUI**: A user-friendly web interface for LLMs.
*   **Searx-ng**: A privacy-respecting, hackable metasearch engine.
*   **Unifi**: The Unifi Network Application.
*   **Vault**: A secret management tool from HashiCorp.
*   **Vaultwarden**: An unofficial Bitwarden server implementation.
*   **Windmill**: An open-source developer platform to build production-grade workflows and UIs from scripts.

### Work in Progress (WIP)

The following services are still under development and may not be fully functional:

*   **Audiomuse-AI**
*   **Changedetection.io**
*   **Crafty Controller**
*   **Feedcord**
*   **i2p**
*   **Jellyfin**
*   **Music-Stack**
*   **Ollama**
*   **Proxy**
*   **Shorts-Bot**
*   **trilium-Next**
*   **Warrior**

## Ansible Roles and Playbooks

The main playbook is `rootless_services.yaml`, which includes the playbooks for each service. The `init.yaml` playbook is used to initialize the servers and install the necessary dependencies.

The project also includes a number of Ansible roles, which are used to configure the services. The roles are located in the `roles/` directory.

## Directory Structure

The directory structure of the project is as follows:

```
.
├── files
│   └── services
│       ├── <service-name>
│       │   ├── config
│       │   ├── quadlets
│       │   └── tasks
├── inventory
├── roles
└── templates
```

*   `files/services`: Contains the quadlet files and Ansible tasks for each service.
*   `inventory`: Contains the Ansible inventory files.
*   `roles`: Contains the Ansible roles.
*   `templates`: Contains universal Jinja2 templates that can be reused for multiple services.

## Templates

Most of the templates in this project do not have the `.j2` extension. This is to allow linters and other tools to continue to work while writing and tweaking the configs.