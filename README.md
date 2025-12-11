# zenlayer-iac-starter
Production-ready automation for Zenlayer Elastic Compute (ZEC). Includes Terraform blueprints for VPC/Compute/LB deployment and Ansible playbooks for configuration.
# Automating Zenlayer Elastic Compute

This repository contains the source code for the blog series "Automating Zenlayer Infrastructure."

## Part 1: Terraform Infrastructure
The `terraform/` directory contains the blueprint for deploying a load-balanced web cluster in the `na-west-1` region.

### Prerequisites
* Terraform v1.0+
* A Zenlayer Cloud account (API Keys required)

### Usage
1. Clone this thing
2. Set Your Password: Create a file named terraform.tfvars inside your local terraform/ directory with the following:

instance_password = "YourSecurePassword123!"

Note: This file is ignored by Git, so your secrets stay safe.

3. Export your API keys (grab this from the Zenlayer portal):
   
   export ZENLAYERCLOUD_ACCESS_KEY_ID="your_access_key"
   export ZENLAYERCLOUD_ACCESS_KEY_PASSWORD="your_secret_key"
   
5. Make sure you have terraform installed and run terraform init/plan/apply!
