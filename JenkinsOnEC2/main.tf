provider "aws" {
  region = var.region
}


resource "aws_instance" "jenkins_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name = "JenkinsOnEc2"
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:/Users/kumar/.aws/JenkinsOnEc2.pem")
  }
  provisioner "remote-exec" {

    inline = [

      # install java
      "sudo yum upgrade -y",
      "sudo yum install java-17-amazon-corretto.x86_64 -y",
      "java --version",

      # install the npm
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash",
      ". ~/.nvm/nvm.sh",
      "nvm install --lts",
      "npm --version",

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
      "echo 'END: Installing Jenkins'"
    ]
  }
}
