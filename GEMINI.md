# Gemini Codebase Analysis: Rules and Patterns

This document outlines the rules and patterns observed in the ansible-deploy codebase, focusing on the deployment of services using Ansible and Podman quadlets.

## 1. Service-Oriented Architecture

The repository is structured around individual services, each residing in its own directory under `files/services/`. This modular approach allows for independent management and deployment of each service.

**Key Characteristics:**

*   **Self-Contained Services:** Each service directory (e.g., `files/services/auth/`) contains all the necessary files for that service, including:
    *   `quadlets/`: Systemd unit files for running the service's containers.
    *   `tasks/`: Ansible tasks for deploying and configuring the service.
    *   `config/`: Default configuration files for the service.
*   **Centralized Dependencies:** While services are self-contained, they rely on centralized dependencies for common functionalities:
    *   **Database:** A central PostgreSQL instance (`centraldb`) is used by multiple services.
    *   **Reverse Proxy:** Caddy is used as a reverse proxy for exposing services to the web.
    *   **Backups:** Borgmatic is used for creating backups of service data.

## 2. Ansible-Driven Deployment

Ansible is the primary tool for orchestrating the deployment and configuration of all services.

**Common Ansible Patterns:**

*   **`install.yaml` Tasks:** Each service has an `install.yaml` (or `install.yml`) file in its `tasks/` directory that defines the deployment logic.
*   **Quadlet Management:** Ansible is responsible for copying or templating quadlet files (`.container`, `.pod`) into the appropriate systemd directories:
    *   User services: `/var/home/{{ user }}/.config/containers/systemd/`
    *   System services: `/etc/containers/systemd/`
*   **Directory Scaffolding:** Ansible creates the necessary application data directories, typically under `/var/home/{{ user }}/appdata/` or `/var/appdata/`.
*   **Secret Management:** A two-tiered approach to secret management is used:
    *   `containers.podman.podman_secret`: For managing secrets that are directly consumed by Podman containers.
    *   `systemd-creds`: For managing system-level secrets that can be exposed to services.
*   **Database Provisioning:** For services that require a database, Ansible tasks are used to create the necessary users and databases in the central PostgreSQL instance.
*   **Configuration Drop-ins:** Ansible templates and copies configuration files for other services (like Caddy and Borgmatic) into their respective `.d` directories (e.g., `/var/home/proxy/appdata/caddy/caddyfile.d/`, `/etc/borgmatic.d/`).
*   **Service Activation:** The final step in each `install.yaml` is to enable and start the service using the `ansible.builtin.systemd_service` module.

## 3. Podman and Quadlets for Containerization

The project uses Podman as its container runtime, with systemd integration managed through quadlets.

**Quadlet Conventions:**

*   **INI Format:** Quadlet files use an INI-style format with sections like `[Unit]`, `[Service]`, and `[Container]`.
*   **Pods:** Services composed of multiple containers are defined using `.pod` files. Containers are associated with a pod using the `Pod=` directive in their `.container` file.
*   **Image Management:**
    *   Container images are sourced from various registries, including `ghcr.io`, `docker.io`, and `lscr.io`.
    *   `AutoUpdate=registry` is consistently used to ensure that services are running the latest version of their container images.
*   **User and System Services:**
    *   **User Services:** Run under a non-root user and often use `User=1000:1000` and `UserNS=keep-id...`.
    *   **System Services:** Run as system-level services and may specify a different user (e.g., `User=2500:2500` for `postgres`).
*   **Networking:**
    *   Pods define the network namespace and port mappings for their containers.
    *   `Network=pasta:-T,...` is used to expose container ports to the host.
    *   `Network=host` is used for services that require direct access to the host's network stack.
*   **Volumes:**
    *   Application data is persisted using host-mounted volumes.
    *   `%h` is used as a placeholder for the user's home directory in user-level quadlets.
*   **Secrets:** Secrets are securely passed to containers as environment variables using the `Secret=` directive.
*   **Health Checks:** The `HealthCmd` directive is used to define health checks for many of the services.

## 4. Naming and Directory Conventions

*   **Service Directory:** `files/services/<service-name>/`
*   **Quadlet Directory:** `files/services/<service-name>/quadlets/`
*   **Task Directory:** `files/services/<service-name>/tasks/`
*   **Config Directory:** `files/services/<service-name>/config/`
*   **Appdata Directory (User):** `/var/home/{{ user }}/appdata/<service-name>/`
*   **Appdata Directory (System):** `/var/appdata/<service-name>/`
*   **Quadlet Files:** `<service-name>.container`, `<service-name>.pod`
*   **Ansible Task File:** `install.yaml` or `install.yml`
