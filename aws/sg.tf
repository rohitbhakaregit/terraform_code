## Security Group for Public server

resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "All"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

## Security Group for private server

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

## Allow all traffic to private server from vpc
resource "aws_security_group_rule" "all_traffic_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.private_sg.id
}
