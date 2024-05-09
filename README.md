# Proyecto-Final-Integraci-n-de-tecnolog-as.
Despliegue Automatizado de WordPress en AWS con Terraform, Ansible y Vault
Este proyecto tiene como objetivo automatizar el despliegue de WordPress en instancias EC2 de AWS utilizando Terraform para el aprovisionamiento de infraestructura, Ansible para la configuración de la aplicación y Vault para la gestión segura de secretos.

Requisitos
Terraform
Ansible
Vault
Acceso a una cuenta de AWS con permisos para crear instancias EC2
Estructura del Proyecto
terraform/: Contiene los archivos de configuración de Terraform para el aprovisionamiento de la infraestructura en AWS.
ansible/: Contiene los playbooks y roles de Ansible para la configuración de WordPress.
scripts/: Scripts adicionales necesarios para el despliegue automatizado.
README.md: Este archivo que estás leyendo.
Pasos para el Despliegue
Clona este repositorio en tu máquina local.
Configura tus credenciales de AWS y Vault.
Ejecuta Terraform para aprovisionar la infraestructura en AWS.
bash
Copy code
cd terraform/
terraform init
terraform apply
Ejecuta Ansible para configurar y desplegar WordPress en la instancia EC2.
bash
Copy code
cd ../ansible/
ansible-playbook wordpress.yml
Accede a la dirección IP pública de la instancia EC2 en tu navegador para verificar que WordPress esté funcionando correctamente.
