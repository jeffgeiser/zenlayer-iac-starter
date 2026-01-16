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
* [Terraform v1.0+](https://developer.hashicorp.com/terraform/downloads)
* A [Zenlayer Cloud](https://console.zenlayer.com/) account (API Keys required)

### 2. Setup
Clone the repository and navigate to the Part 1 directory:
```bash
git clone https://github.com/jeffgeiser/zenlayer-iac-starter.git
cd zenlayer-iac-starter/01-basic-cluster
```

### 3. Configure Secrets
Create a file named `terraform.tfvars` inside the `01-basic-cluster` directory to set your server password securely:

```hcl
# 01-basic-cluster/terraform.tfvars
instance_password = "YourSecurePassword123!"
```

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

**Result:** You will see an `Apply complete!` message and the terminal will output your new Load Balancer IP.

---

## Part 2 (Ansible Integration)
For the advanced configuration guide, navigate to the `02-ansible-integration` directory and refer to the blog post instructions.
