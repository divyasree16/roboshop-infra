data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = [ "973714476881"]
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = var.component
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.component}-${var.env}sg"
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.component}-${var.env}sg"
  }
}


resource "aws_route53_record" "record" {
  zone_id = "Z039916038KM3J6GJYRJC"
  name    = "${var.component}-dev.devops161997.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.ec2.private_ip]
}

variable "component" {}
variable "instance_type" {}
variable "sg_id" {}
variable "env" {
  default = "dev"
}




