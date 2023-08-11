provider "aws" {
  region = var.region
}

# please refer below to attach a role to ec2
# https://skundunotes.com/2021/11/16/attach-iam-role-to-aws-ec2-instance-using-terraform/
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "EcrAdmin"
}

resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = {
    Name = var.tag_name
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = "JenkinsOnEc2"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("C:/Users/kumar/.aws/JenkinsOnEc2.pem")
    }
    provisioner "remote-exec" {

      inline = [

        #install git
        "sudo yum install git -y",
        "git -v",

        # install java
        "sudo yum upgrade -y",
        "sudo yum install java-17-amazon-corretto.x86_64 -y",
        "java --version",

        # install docker
        "sudo yum install docker -y",
        "docker --version",

        # install jenkins
        # https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
        "echo 'START: Installing Jenkins'",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo",
        "sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key",
        "sudo yum install jenkins -y",
        "sudo systemctl enable jenkins",
        "sudo systemctl start jenkins",
        "echo 'END: Installing Jenkins'",

        # add jenkins user to docker group
        "sudo usermod -a -G docker jenkins",

        # restart jenkins server
        "sudo service jenkins restart",

        # reload system demon files
        "sudo systemctl daemon-reload",

        # restart docker service
        "sudo service docker stop",
        "sudo service docker start"

      ]
    }
}
