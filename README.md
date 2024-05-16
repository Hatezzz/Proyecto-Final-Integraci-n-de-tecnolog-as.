Despliegue de Infraestructura con Terraform
Este proyecto utiliza Terraform para desplegar una infraestructura básica en AWS usando terraform y Ansible.

Prerrequisitos
Antes de comenzar, asegúrate de tener lo siguiente:

- Cuenta de AWS con credenciales de acceso y permisos adecuados.
- Terraform instalado localmente en tu máquina.
- Claves SSH generadas para acceder a las instancias EC2 (las claves SSH deben de tener el siguiente nombre aws-key-pair).
- Amsible instalado en tu máquina.

Conocimiento básico de Terraform y AWS.
Qué se hizo
Creación de una VPC con tres subredes públicas en diferentes zonas de disponibilidad.
Configuración de un grupo de seguridad para permitir el tráfico SSH, HTTP, HTTPS y MySQL/Aurora.
Provisionamiento de un grupo de subredes para la base de datos RDS.
Creación de una instancia de base de datos RDS MySQL.
Creación de una instancia EC2 para alojar una aplicación web de WordPress.
Asociación de una dirección IP elástica a la instancia EC2.
Configuación de las máquinas EC2 con Ansible.
Configuración de un archivo de juego de Ansible para la instalación de WordPress.

Cómo usar
Clona este repositorio en tu máquina local.

Asegúrate de tener configurado correctamente el acceso a tu cuenta de AWS en tu entorno.

Configura tus variables de entorno o modifica el archivo terraform.tfvars para personalizar la configuración según tus necesidades.

Ejecuta los siguientes comandos en la terminal:


- terraform init
- terraform plan
- terraform apply

Una vez completado el despliegue, podrás acceder a la aplicación WordPress utilizando la dirección IP pública de la instancia EC2.
