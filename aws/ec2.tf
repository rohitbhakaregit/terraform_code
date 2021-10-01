resource "aws_instance" "web" {
  count           = length(var.public_subnets_cidr)
  ami             = var.ami
  instance_type   = var.ec2_instance_class
  key_name        = var.ec2_key_name
  security_groups = ["${aws_security_group.public_sg.id}"]
  subnet_id       = element(aws_subnet.public.*.id, count.index + 0)


  user_data = <<-EOF
                #!/bin/bash
                # install ansible
                sudo apt-add-repository ppa:ansible/ansible -y 
                sudo apt update -y
                sudo apt install ansible -y
                # install java 8
                export PATH=$PATH:/usr/bin
                sudo add-apt-repository -y ppa:webupd8team/java
                sudo apt-get update
                sudo apt-get -y install oracle-java8-installer
                export JAVA_HOME=/usr/lib/jvm/java-8-oracle
                sudo apt-get update
                echo $JAVA_HOME
                # install jenkins
                wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
                sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'  -y
                sudo apt update -y
                sudo apt install jenkins -y 
                # creating directory
                mkdir -p /mnt/artefact
                EOF
  
  provisioner "file" {
    source      = "universal.pem"
    destination = "/tmp"
  }

  tags = {
    Name = "web"
  }

  lifecycle {
    create_before_destroy = "true"
  }
}

resource "aws_instance" "app" {
  count           = length(var.private_subnets_cidr)
  ami             = var.ami
  instance_type   = var.ec2_instance_class
  key_name        = var.ec2_key_name
  security_groups = ["${aws_security_group.private_sg.id}"]
  subnet_id       = element(aws_subnet.private.*.id, count.index + 0)

  user_data = <<-EOF
                #!/bin/bash
                # install java 8
                export PATH=$PATH:/usr/bin
                sudo add-apt-repository -y ppa:webupd8team/java
                sudo apt-get update
                sudo apt-get -y install oracle-java8-installer
                export JAVA_HOME=/usr/lib/jvm/java-8-oracle
                sudo apt-get update
                echo $JAVA_HOME
                # creating directory
                mkdir -p /mnt/artefact
                EOF
  
  tags = {
    Name = "app"
  }
  
  lifecycle {
    create_before_destroy = "true"
  }
}
