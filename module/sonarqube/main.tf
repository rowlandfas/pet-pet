
# Creating security group for SonarQube
resource "aws_security_group" "sonarqube-sg" {
  name        = "${var.name}-sonarqube-sg"
  description = "Allow inbound traffic from lb and all outbound traffic"
  vpc_id      = var.vpc

  # Ingress rule: Allow SonarQube web UI (port 9000) from within VPC
  ingress {
    description = "SonarQube Web UI (port 9000)"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    security_groups = [ aws_security_group.lb-sg.id ]
    # cidr_blocks = [var.vpc_cidr_block]  # Allow from the VPC CIDR block
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound to anywhere
  }

  tags = {
    Name = "${var.name}-sonarqube-sg"
  }
}

# Creating security group for LoadBalancer
resource "aws_security_group" "lb-sg" {
  name        = "${var.name}-lb-sg"
  description = "Allow inbound traffic for lb and all outbound traffic"
  vpc_id      = var.vpc

  
  # Ingress rule: Allow HTTPS (port 443) from within VPC
  ingress {
    description = "HTTPS (port 443)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]  # Allow from the VPC CIDR block
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound to anywhere
  }

  tags = {
    Name = "${var.name}-lb-sg"
  }
}


# Data source to get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners   = ["099720109477"] # Canonical
}

# Create Sonarqube Server
resource "aws_instance" "sonarqube-server" {
  ami                    = data.aws_ami.ubuntu.id #ubuntu 
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.sonarqube-sg.id]
  key_name               = var.keypair
  subnet_id              = var.subnet_id
  user_data              = file("${path.module}/sonar_userdata.sh")
  
  tags = {
    Name = "${var.name}-sonarqube-server"
  }
}

# create loadbalancer for the sonarqube
resource "aws_lb" "sonarqube-lb" {
  name               = "${var.name}-sonarqube-lb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [var.subnet_id]

  # enable_deletion_protection = true
  
  tags = {
    Name = "${var.name}-sonarqube-lb"
  }
}

# Fetch the Hosted Zone
data "aws_route53_zone" "main" {
  name         = "learnnewway.site"  
  private_zone = false          
}

# Create a DNS record for the ALB
resource "aws_route53_record" "sonarqube" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "learnnewway.site"
  type    = "A"

  alias {
    name                   = aws_lb.sonarqube-lb.dns_name
    zone_id                = aws_lb.sonarqube-lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_lb.sonarqube-lb]
}

# create an IAM instance role
resource "aws_iam_role" "sonarqube-role" {
  name = "${var.name}-sonarqube-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.name}-sonarqube-role"
  }
}

# sonarqube IAM profile
resource "aws_iam_instance_profile" "sonarqube_profile" {
  name = "${var.name}-sonarqube-profile"
  role = aws_iam_role.sonarqube-role.name
}

# SSM permission
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.sonarqube-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}