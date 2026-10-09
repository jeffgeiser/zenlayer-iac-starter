# Zenlayer IaC Starter

**Production-ready automation for Zenlayer Elastic Compute (ZEC).**

This repository provides a complete blueprint for deploying a load-balanced web cluster using Terraform and Ansible.

## Repository Structure

The code is organized into chapters:

* **`01-basic-cluster` (Part 1):** A "Pure Terraform" implementation. Deploys the VPC, Security Groups, Compute Nodes, and Load Balancer.
* **`02-ansible-integration` (Part 2):** Builds upon the basic cluster by adding dynamic inventory generation and Ansible playbooks to configure the servers (Nginx + Web Content).

---

## Quick Start: Part 1 (Basic Cluster)

Follow these steps to deploy the infrastructure from **Part 1**.

### 1. Prerequisites
* [Terraform v1.3+](https://developer.hashicorp.com/terraform/downloads)
* A [Zenlayer Cloud](https://console.zenlayer.com/) account (API Keys required)

### 2. Setup
Clone the repository and navigate to the Part 1 directory:
```bash
git clone https://github.com/jeffgeiser/zenlayer-iac-starter.git
cd zenlayer-iac-starter/01-basic-cluster
```

### 3. Configure Variables
Copy the example file and fill it in. `terraform.tfvars` is git-ignored, so nothing here gets committed:

```bash
cp terraform.tfvars.example terraform.tfvars
```

```hcl
# 01-basic-cluster/terraform.tfvars
ssh_public_key   = "ssh-ed25519 AAAA... you@laptop"   # contents of ~/.ssh/id_ed25519.pub
ssh_allowed_cidr = "203.0.113.10/32"                  # your IP or VPN egress; never 0.0.0.0/0

# Optional console password. Leave unset to log in with your SSH key only.
# instance_password = "change-me"
```

| Variable | Required | Description |
|---|---|---|
| `ssh_public_key` | yes | OpenSSH public key installed on every node (key-based login). |
| `ssh_allowed_cidr` | yes | The only CIDR allowed to reach port 22. |
| `ssh_key_name` | no | Name of the Zenlayer key pair (default `zenlayer-iac-starter`). |
| `instance_password` | no | Sensitive. Optional root password for console access; prefer `TF_VAR_instance_password` over a file. |

The Zenlayer provider is pinned (`~> 0.2.31`) in `versions.tf`, and `.terraform.lock.hcl` is committed so everyone gets the same provider build.

### 4. Deploy
Export your Zenlayer API keys (found in the Console under "Security"):

```bash
export ZENLAYERCLOUD_ACCESS_KEY_ID="your_access_key_id"
export ZENLAYERCLOUD_ACCESS_KEY_PASSWORD="your_secret_key"
```

Initialize and apply the Terraform configuration:

```bash
terraform init
terraform apply
```

**Result:** You will see an `Apply complete!` message and the terminal will output your new Load Balancer IP. Log in with `ssh root@<vm_public_ip>` using the private key that matches `ssh_public_key`.

---

## Part 2 (Ansible Integration)
Part 2 takes the same variables (see `02-ansible-integration/terraform/terraform.tfvars.example`). For the advanced configuration guide, navigate to the `02-ansible-integration` directory and refer to the blog post instructions.
