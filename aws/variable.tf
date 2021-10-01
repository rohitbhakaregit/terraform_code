variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.20.0.0/16"
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = ["172.20.20.0/24"]
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = ["172.20.10.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "ami" {
  default = "ami-068663a3c619dd892"
}

variable "ec2_instance_class" {
  default = "t2.micro"
}


variable "ec2_key_name" {
  default = "universal"
}
