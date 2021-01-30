resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "prod-igw"
  }
}

resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    // associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    // CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.prod-igw.id
  }
  tags = {
    Name = "prod-public-crt"
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.prod-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // This means, all ip address are allowed to ssh !
    // Do not do it in the production.
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }
  //If you do not add this rule, you can not reach the public ip
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh-allowed"
  }
}

resource "aws_instance" "web1" {
  ami           = var.AMI
  instance_type = "t2.micro"
  # VPC
  subnet_id = aws_subnet.prod-subnet-public-1.id
  # Security Group
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
  # the Public SSH key
  key_name = aws_key_pair.aws-key-pair.id
  # nginx installation
  provisioner "remote-exec" {
    inline = var.WEB_SCRIPT
  }
  connection {
    user        = var.EC2_USER
    private_key = file(var.PRIVATE_KEY_PATH)
    host        = self.public_ip
  }
}

resource "aws_instance" "web2" {
  ami           = var.AMI
  instance_type = "t2.micro"
  # VPC
  subnet_id = aws_subnet.prod-subnet-public-1.id
  # Security Group
  vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
  # the Public SSH key
  key_name = aws_key_pair.aws-key-pair.id
  # nginx installation
  provisioner "remote-exec" {
    inline = var.WEB_SCRIPT
  }
  connection {
    user        = var.EC2_USER
    private_key = file(var.PRIVATE_KEY_PATH)
    host        = self.public_ip
  }
}

// Sends your public key to the instance
resource "aws_key_pair" "aws-key-pair" {
  key_name   = "aws-key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}
