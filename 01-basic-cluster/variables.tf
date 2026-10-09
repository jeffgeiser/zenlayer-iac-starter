variable "ssh_public_key" {
  description = "OpenSSH public key installed on every node (e.g. the contents of ~/.ssh/id_ed25519.pub). Used for key-based SSH login."
  type        = string

  validation {
    condition     = can(regex("^(ssh-(ed25519|rsa)|ecdsa-sha2-nistp(256|384|521)) ", var.ssh_public_key))
    error_message = "ssh_public_key must be an OpenSSH public key (ssh-ed25519, ssh-rsa or ecdsa-sha2-*)."
  }
}

variable "ssh_key_name" {
  description = "Name of the Zenlayer key pair created from ssh_public_key (letters, digits, - and _; max 32 characters)."
  type        = string
  default     = "zenlayer-iac-starter"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to reach SSH (port 22), e.g. your office or VPN egress \"203.0.113.10/32\". There is deliberately no default: do not use 0.0.0.0/0."
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr must be a valid CIDR block, e.g. 203.0.113.10/32."
  }
}

variable "instance_password" {
  description = "Optional root password for console access. Leave null to rely on SSH keys only. Never commit it: set it in terraform.tfvars (git-ignored) or TF_VAR_instance_password."
  type        = string
  sensitive   = true
  default     = null
}
