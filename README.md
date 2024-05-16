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

Arquitectura de la Solución
Este proyecto despliega una infraestructura básica en AWS utilizando Terraform y Ansible. La arquitectura de la solución comprende los siguientes componentes principales:

1. Virtual Private Cloud (VPC)
Se crea una VPC con el rango de direcciones IP 10.0.0.0/16. Esta VPC permite el aislamiento lógico de recursos desplegados en AWS.

2. Subredes Públicas
Se crean tres subredes públicas en diferentes zonas de disponibilidad (AZ) de AWS:

Subred Pública 1: CIDR 10.0.1.0/24
Subred Pública 2: CIDR 10.0.2.0/24
Subred Pública 3: CIDR 10.0.3.0/24
Estas subredes están configuradas para asignar direcciones IP públicas a las instancias EC2 desplegadas en ellas.

3. Internet Gateway (IGW) y Tabla de Ruteo
Se crea un Internet Gateway (IGW) y se asocia con la VPC para permitir el tráfico de entrada y salida hacia y desde Internet. Además, se configura una tabla de ruteo para dirigir el tráfico de salida a través del IGW.

4. Grupos de Seguridad
Se definen dos grupos de seguridad:

Grupo de Seguridad EC2: Permite el tráfico SSH (puerto 22), HTTP (puerto 80), HTTPS (puerto 443) y MySQL/Aurora (puerto 3306) desde cualquier dirección IP.
Grupo de Seguridad RDS: Permite el tráfico MySQL (puerto 3306) desde el grupo de seguridad EC2.
5. Base de Datos RDS
Se despliega una instancia de base de datos RDS MySQL en las subredes públicas creadas, con la configuración especificada en las variables de entrada. Esta instancia utiliza el grupo de seguridad RDS para controlar el acceso.

6. Instancia EC2 para WordPress
Se crea una instancia EC2 para alojar una aplicación web de WordPress. Esta instancia se encuentra en la primera subred pública y utiliza el grupo de seguridad EC2 para controlar el acceso. Se asigna una dirección IP elástica a esta instancia para facilitar el acceso externo.

Cómo usar
Clona este repositorio en tu máquina local.

Asegúrate de tener configurado correctamente el acceso a tu cuenta de AWS en tu entorno.

Configura tus variables de entorno o modifica el archivo terraform.tfvars para personalizar la configuración según tus necesidades.

Ejecuta los siguientes comandos en la terminal:


- terraform init
- terraform plan
- terraform apply

Una vez completado el despliegue, podrás acceder a la aplicación WordPress utilizando la dirección IP pública de la instancia EC2.
