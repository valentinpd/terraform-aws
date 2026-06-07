###############################################################################
# Módulo: networking
# Crea la red base donde vivirán las instancias:
#   VPC -> subred pública -> internet gateway -> tabla de rutas -> asociación
###############################################################################

# Red privada virtual (VPC). enable_dns_* permite resolver nombres dentro.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subred pública. map_public_ip_on_launch asigna IP pública automáticamente.
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Internet Gateway: la puerta de salida/entrada a Internet de la VPC.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tabla de rutas: envía todo el tráfico (0.0.0.0/0) hacia el internet gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Asocia la tabla de rutas a la subred pública (sin esto, la ruta no aplica).
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
