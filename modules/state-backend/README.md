# Módulo: state-backend

Crea la infraestructura donde Terraform guarda su **estado remoto** de forma segura.

## Qué crea

- **Bucket S3** para el fichero `.tfstate`, con:
  - Cifrado en reposo (AES-256)
  - Versionado (historial para recuperar)
  - Acceso público bloqueado
  - `prevent_destroy` (no se puede borrar por accidente)

El **bloqueo (lock)** del estado no necesita un recurso aparte: lo hace el propio
S3 con un fichero `.tflock` (`use_lockfile = true` en `providers.tf`), gracias a
las escrituras condicionales de S3. Antes esto se hacía con una tabla DynamoDB.

> Nota: este bucket es el "soporte" del backend definido en `providers.tf`.
> Existe una dependencia de arranque (huevo/gallina) entre crearlo y usarlo como
> backend; por eso, en un proyecto nuevo, se crea primero y luego se activa el
> backend `s3`.

## Variables de entrada

| Nombre              | Tipo   | Descripción                        |
| ------------------- | ------ | ---------------------------------- |
| `project_name`      | string | Prefijo para nombres/etiquetas.    |
| `state_bucket_name` | string | Nombre global único del bucket S3. |

## Salidas (outputs)

| Nombre       | Descripción                   |
| ------------ | ----------------------------- |
| `bucket_arn` | ARN del bucket S3 del estado. |

## Ejemplo de uso

```hcl
module "state_backend" {
  source            = "./modules/state-backend"
  project_name      = var.project_name
  state_bucket_name = var.state_bucket_name
}
```
