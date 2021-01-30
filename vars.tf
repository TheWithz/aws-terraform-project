variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AWS_CREDS" {
  default = "/home/thewithz/.aws/credentials"
}

variable "AWS_PROFILE" {
  default = "terraform"
}

variable "AMI" {
  default = "ami-0885b1f6bd170450c"
}

variable "PUBLIC_KEY_PATH" {
  default = "/home/thewithz/.ssh/aws-key-pair.pub"
}

variable "PRIVATE_KEY_PATH" {
  default = "/home/thewithz/.ssh/aws-key-pair"
}

variable "EC2_USER" {
  default = "ubuntu"
}

variable "WEB_SCRIPT" {
  default = [
    "sudo apt update -y",
    "sudo apt upgrade -y",
    "sudo apt install nginx -y",
    "sudo systemctl start nginx",
    "sudo systemctl enable nginx",
    "cat << EOF > ~/index.html\nHello, World!\nEOF",
    "sudo mv ~/index.html /var/www/html/"
  ]
}
