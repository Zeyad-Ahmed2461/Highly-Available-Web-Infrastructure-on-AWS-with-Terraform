resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "zeyad-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/zeyad-key.pem"
  file_permission = "0600"
}

output "private_key_file" {
  value       = local_file.private_key.filename
  description = "Path to the generated private key"
}
