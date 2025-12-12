terraform {
  required_providers {
    zenlayercloud = {
      source = "zenlayer/zenlayercloud"
    }
  }
}

provider "zenlayercloud" {}

# 0. DATA SOURCES
data "zenlayercloud_zec_images" "ubuntu" {
  image_name_regex  = "^Ubuntu Server 20.04"
  availability_zone = "na-west-1a"
}

# 1. NETWORK
resource "zenlayercloud_zec_vpc" "test_vpc" {
  name       = "terraform-zec-vpc"
  cidr_block = "10.0.0.0/16"
}

resource "zenlayercloud_zec_subnet" "test_subnet" {
  vpc_id     = zenlayercloud_zec_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  name       = "terraform-zec-subnet"
  region_id  = "na-west-1"
}

# 2. SECURITY GROUP
resource "zenlayercloud_zec_security_group" "web_sg" {
  name = "terraform-zec-sg"
}

resource "zenlayercloud_zec_security_group_rule_set" "web_rules" {
  security_group_id = zenlayercloud_zec_security_group.web_sg.id

  ingress {
    policy      = "accept"
    port        = "22"
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    priority    = 1
  }

  ingress {
    policy      = "accept"
    port        = "80"
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    priority    = 1
  }
}

# 3. COMPUTE
resource "zenlayercloud_zec_instance" "web_nodes" {
  count              = 2
  instance_name      = "tf-zec-node-${count.index + 1}"
  instance_type      = "z2a.cpu.1"
  image_id           = data.zenlayercloud_zec_images.ubuntu.images[0].id
  subnet_id          = zenlayercloud_zec_subnet.test_subnet.id
  security_group_id  = zenlayercloud_zec_security_group.web_sg.id
  availability_zone  = "na-west-1a"
  password           = var.instance_password
  system_disk_size   = 40
  
  # Ensure rules are active before booting 
  depends_on = [zenlayercloud_zec_security_group_rule_set.web_rules]
}

# 4. LOAD BALANCER
resource "zenlayercloud_zlb_instance" "web_lb" {
  zlb_name   = "tf-zec-lb"
  region_id  = "na-west-1"
  vpc_id     = zenlayercloud_zec_vpc.test_vpc.id
  depends_on = [zenlayercloud_zec_subnet.test_subnet]
}

resource "zenlayercloud_zlb_listener" "http" {
  zlb_id               = zenlayercloud_zlb_instance.web_lb.id
  listener_name        = "http-80"
  protocol             = "TCP"
  port                 = 80
  health_check_enabled = true
  health_check_type    = "TCP"
  scheduler            = "mh"
  kind                 = "FNAT"
}

resource "zenlayercloud_zlb_backend" "attach_vms" {
  count       = 2
  zlb_id      = zenlayercloud_zlb_instance.web_lb.id
  
  # Extracting the UUID correctly
  listener_id = split(":", zenlayercloud_zlb_listener.http.id)[1]

  backends {
    instance_id        = zenlayercloud_zec_instance.web_nodes[count.index].id
    private_ip_address = tolist(zenlayercloud_zec_instance.web_nodes[count.index].private_ip_addresses)[0]
    port               = 80
  }
}

# 5. OUTPUTS
output "load_balancer_ip" {
  value = zenlayercloud_zlb_instance.web_lb.public_ip_addresses
}

output "vm_public_ips" {
  value = zenlayercloud_zec_instance.web_nodes[*].public_ip_addresses
}
