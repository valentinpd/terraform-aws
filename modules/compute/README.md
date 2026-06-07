# Módulo: compute

Lanza una **instancia EC2 (Ubuntu 22.04)** en una subred pública, protegida por
un security group restrictivo.

## Qué crea

- **Security Group** que permite SSH (puerto 22) **solo** desde `ssh_allowed_cidr`
  y salida a todo Internet.
- **Instancia EC2** con IP pública, usando la AMI más reciente de Ubuntu 22.04
  (resuelta dinámicamente con un `data "aws_ami"`, sin cablear el ID).

## Variables de entrada

| Nombre             | Tipo   | Por defecto | Descripción                                  |
| ------------------ | ------ | ----------- | -------------------------------------------- |
| `project_name`     | string | —           | Prefijo para nombres/etiquetas.              |
| `vpc_id`           | string | —           | ID de la VPC donde crear el security group.  |
| `subnet_id`        | string | —           | ID de la subred donde lanzar la instancia.   |
| `instance_type`    | string | `t3.micro`  | Tipo de instancia EC2.                       |
| `ssh_allowed_cidr` | string | —           | CIDR autorizado para SSH (usa tu IP `/32`).  |

## Salidas (outputs)

| Nombre              | Descripción                       |
| ------------------- | --------------------------------- |
| `ec2_public_ip`     | IP pública de la instancia EC2.   |
| `security_group_id` | ID del security group creado.     |

## Ejemplo de uso

```hcl
module "compute" {
  source           = "./modules/compute"
  project_name     = var.project_name
  vpc_id           = module.networking.vpc_id
  subnet_id        = module.networking.public_subnet_id
  instance_type    = var.instance_type
  ssh_allowed_cidr = var.ssh_allowed_cidr
}
```
