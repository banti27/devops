variable "region" {
  type = string
  default = "ap-south-1"
}

variable "ami_id" {
    type = string
    default = "ami-02bc45136ff0b128e"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "tag_name" {
    type = string
    default = "devops"
}