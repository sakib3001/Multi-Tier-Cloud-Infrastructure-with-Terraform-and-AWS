module "networking" {
  source = "./modules/networking"
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_security_group" "web-sg" {
  
  vpc_id = module.networking.vpc_id
  name = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "db-sg" {
  
  vpc_id = module.networking.vpc_id
  name = "db-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["11.0.0.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["11.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "web-server" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "test"

  associate_public_ip_address = true

  subnet_id = module.networking.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web-sg.id]


  tags = {
    Name = "web-server"
  }

  user_data = file("user-data.sh")

}

resource "aws_key_pair" "test" {
  key_name = "test"
  public_key = var.public_key
}

resource "aws_instance" "db-server" {
  
  ami = var.ami
  instance_type = var.instance_type
  key_name = "test"

  subnet_id = module.networking.private_subnet_id
  vpc_security_group_ids = [aws_security_group.db-sg.id]

  tags = {
    Name = "db-server"
  }
}