###############################################################################
# Módulo: compute
# Lanza una instancia EC2 (Ubuntu 22.04) en la subred pública, protegida por
# un security group que solo permite SSH desde tu IP.
###############################################################################

# Data source: busca dinámicamente la AMI más reciente de Ubuntu 22.04.
# Así no hay que cablear un ID de AMI que cambia con cada actualización.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (propietario oficial de Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Cortafuegos de la instancia. Entrada: solo SSH desde var.ssh_allowed_cidr.
resource "aws_security_group" "web" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow inbound SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Salida: permitido todo (la instancia puede actualizarse, descargar, etc.).
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# Instancia EC2. Usa la AMI encontrada arriba y la red recibida por variables.
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-web-server"
  }
}
