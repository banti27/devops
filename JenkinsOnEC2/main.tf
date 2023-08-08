provider "aws" {
    region = var.region
}


resource "aws_instance" "jenkins_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
}