variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "project_name" {
  default = "jenkins-aws-demo"
}
