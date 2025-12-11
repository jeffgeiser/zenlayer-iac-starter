# terraform/variables.tf

variable "instance_password" {
  description = "The root password for the web servers"
  type        = string
  sensitive   = true
}
