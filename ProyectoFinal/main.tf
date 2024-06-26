provider "aws" {
  region = var.region
}

# Crear VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
}

# Subnet de EC2 1
resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.AZ1
}

# Subnet de EC2 2
resource "aws_subnet" "prod-subnet-public-2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.AZ2
}

# Subnet de EC2 3
resource "aws_subnet" "prod-subnet-public-3" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.AZ3
}


# Crear Internet Gateway (IGW)
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# Crear la tabla de ruteo
resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

# Grupo de seguridad
resource "aws_security_group" "ec2_allow_rule" {
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

  tags = {
    Name = "allow ssh,http,https"
  }
}

# Grupo de seguridad para RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_allow_rule.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow ec2"
  }
}


resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = [
    aws_subnet.prod-subnet-public-1.id,
    aws_subnet.prod-subnet-public-2.id,
    aws_subnet.prod-subnet-public-3.id,  
  ]
}
# Crear instancia de base de datos RDS
resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.RDS_subnet_grp.id
  vpc_security_group_ids = [aws_security_group.RDS_allow_rule.id]
  db_name              = var.database_name
  username             = var.database_user
  password             = var.database_password
  skip_final_snapshot  = true
}

# Plantilla para archivo de juego de ansible
data "template_file" "playbook" {
  template = file("${path.module}/playbook_test.yml")
  vars = {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpressdb.endpoint
  }
}

# Crear instancia EC2
resource "aws_instance" "wordpressec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.prod-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.ec2_allow_rule.id]
  key_name               = aws_key_pair.aws-key-pair.id

  tags = {
    Name = "Wordpress.web"
  }
}

# Crear par de claves
resource "aws_key_pair" "aws-key-pair" {
  key_name   = "aws-key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

# Crear dirección IP elástica para EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id
}

output "IP" {
  value = aws_eip.eip.public_ip
}

output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

resource "local_file" "playbook-rendered-file" {
  content = "${data.template_file.playbook.rendered}"
  filename = "./playbook-rendered.yml"
}

resource "null_resource" "Wordpress_Installation_Waiting" {

triggers={
    ec2_id=aws_instance.wordpressec2.id,
    rds_endpoint=aws_db_instance.wordpressdb.endpoint
    
    }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.PRIV_KEY_PATH)
    host        = aws_eip.eip.public_ip
  }

  provisioner "remote-exec" {
     
     inline = ["sudo yum update -y","sudo yum install python3 -y", "echo Done!"]
   
  }

  provisioner "local-exec" {
     command = <<EOT
     export ANSIBLE_HOST_KEY_CHECKING=False; 
     ansible-playbook -u ec2-user -i '${aws_eip.eip.public_ip},' --private-key ${var.PRIV_KEY_PATH}  playbook-rendered.yml
     
     EOT  

}

}



