# Módulo: networking

Crea la **red base** sobre la que se despliegan las instancias.

## Qué crea

- **VPC** (con DNS habilitado)
- **Subred pública** (asigna IP pública automáticamente)
- **Internet Gateway**
- **Tabla de rutas** con salida a Internet (`0.0.0.0/0`) y su asociación a la subred

## Variables de entrada

| Nombre               | Tipo   | Descripción                       |
| -------------------- | ------ | --------------------------------- |
| `project_name`       | string | Prefijo para nombres/etiquetas.   |
| `vpc_cidr`           | string | CIDR de la VPC (ej. `10.0.0.0/16`). |
| `public_subnet_cidr` | string | CIDR de la subred (ej. `10.0.1.0/24`). |

## Salidas (outputs)

| Nombre             | Descripción              |
| ------------------ | ------------------------ |
| `vpc_id`           | ID de la VPC.            |
| `public_subnet_id` | ID de la subred pública. |

## Ejemplo de uso

```hcl
module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}
```
