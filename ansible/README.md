# Ansible Configuration Layer

Provisioning layer for the EC2 instance launched by Terraform. The included playbook installs a basic Nginx-based app shell and demonstrates how to extend roles for your services.

## Structure
- `ansible.cfg` – points Ansible to the dev inventory, defaults remote user to `ubuntu`, and enables YAML output.
- `site.yml` – entry point playbook targeting the `app` group and applying the `app` role.
- `inventories/dev/hosts.ini` – sample static inventory expecting the Terraform public IP.
- `inventories/dev/group_vars/app.yml` – variables shared by hosts in the `app` group (packages, ports, etc.).
- `roles/app` – baseline role that updates apt, installs packages, and deploys an Nginx landing page.

## Running the playbook
1. Export the Terraform outputs or copy the EC2 public IP into `inventories/dev/hosts.ini` (replace `REPLACE_WITH_PUBLIC_IP`).
2. Ensure the SSH key referenced in the inventory exists (default `~/.ssh/id_rsa`).
3. From the `ansible/` directory run:

```bash
ansible-playbook site.yml
```

Add more inventories (stage/prod), variables, or roles as needed to layer your application services on top of the hardened AMI.
