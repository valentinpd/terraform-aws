# Módulo: state-backend

Crea la infraestructura donde Terraform guarda su **estado remoto** de forma segura.

## Qué crea

- **Bucket S3** para el fichero `.tfstate`, con:
  - Cifrado en reposo (AES-256)
  - Versionado (historial para recuperar)
  - Acceso público bloqueado
  - `prevent_destroy` (no se puede borrar por accidente)
- **Tabla DynamoDB** para el *lock* del estado (evita ejecuciones simultáneas).

> Nota: estos recursos son el "soporte" del backend definido en `providers.tf`.
> Existe una dependencia de arranque (huevo/gallina) entre crearlos y usarlos
> como backend; por eso, en un proyecto nuevo, se crean primero y luego se
> activa el backend `s3`.

## Variables de entrada

| Nombre              | Tipo   | Descripción                                  |
| ------------------- | ------ | -------------------------------------------- |
| `project_name`      | string | Prefijo para nombres/etiquetas.              |
| `state_bucket_name` | string | Nombre global único del bucket S3.           |
| `state_table_name`  | string | Nombre de la tabla DynamoDB de bloqueo.      |

## Salidas (outputs)

| Nombre                | Descripción                          |
| --------------------- | ------------------------------------ |
| `bucket_arn`          | ARN del bucket S3 del estado.        |
| `dynamodb_table_name` | Nombre de la tabla DynamoDB de lock. |

## Ejemplo de uso

```hcl
module "state_backend" {
  source            = "./modules/state-backend"
  project_name      = var.project_name
  state_bucket_name = var.state_bucket_name
  state_table_name  = var.state_table_name
}
```
