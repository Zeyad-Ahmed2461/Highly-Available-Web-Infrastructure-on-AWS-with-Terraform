variable "region" {
  description = "AWS region to deploy resources in"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet1_cidr" {
  description = "CIDR block for public subnet 1"
}

variable "public_subnet2_cidr" {
  description = "CIDR block for public subnet 2"
}

variable "private_subnet1_cidr" {
  description = "CIDR block for private subnet 1"
}

variable "private_subnet2_cidr" {
  description = "CIDR block for private subnet 2"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "ami_id_bastion" {
  description = "AMI ID for Bastion Host"
}

variable "ami_id_asg" {
  description = "AMI ID for ASG instances"
}
