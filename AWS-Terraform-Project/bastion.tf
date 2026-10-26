resource "aws_instance" "bastion" {
  ami                    = var.ami_id_bastion
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.pub_subnet1.id
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.jumper_SG.id]
  associate_public_ip_address = true

  tags = { Name = "Bastion-Host" }
}
