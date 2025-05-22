resource "tls_private_key" "lamp_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_lightsail_key_pair" "lamp_key2" {
  name   = "lamp"
  public_key = tls_private_key.lamp_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "lamp.pem"
  content         = tls_private_key.lamp_key.private_key_pem
}

resource "aws_lightsail_instance" "server1" {
  name              = "lamp-server"           # Name of the Lightsail instance
  availability_zone = "us-east-1a"            # Availability zone
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_3_0"
  key_pair_name     = "lamp"                  # SSH key pair (must already exist)
}