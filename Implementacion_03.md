# Proyecto de Infraestructura IT - Resumen Detallado

## Servidor y Virtualización
- **Servidor**: ProLiant DL380 G7
- **SO**: Rocky Linux 9.3 (Blue Onyx)
- **Virtualización**: KVM/QEMU con Flatcar Container Linux
- **Gestión de Virtualización**: Libvirt

## Red y Conectividad
- **Switch**: TP-Link LS1008G - 8 puertos Gigabit no administrados
- **Router WiFi**: Conexión de fibra óptica 600 Mbps de subida/bajada, IP pública
- **Red**: Configurada con Open vSwitch para manejo avanzado y políticas de red
- **VPN**: WireGuard para acceso seguro administrado por Bastion Node

## Automatización y Gestión
- **Herramientas**: Terraform para infraestructura como código, Ansible para automatización de configuraciones

## Máquinas Virtuales y Roles
- **Total VMs**: 12
- **Roles**:
  - **Bootstrap Node**: 1 CPU, 1024 MB, inicializa clúster
  - **Master Nodes**: 3 x (2 CPUs, 2048 MB), gestionan el clúster
  - **Worker Nodes**: 3 x (2 CPUs, 2048 MB), ejecutan aplicaciones
  - **Bastion Node**: 1 CPU, 1024 MB, seguridad y acceso
  - **Load Balancer**: 1 CPU, 1024 MB, con Traefik

## Servicios Auxiliares
- **FreeIPA**: Gestión de identidades, servidor DNS con BIND
- **NFS y PostgreSQL**: Almacenamiento de datos
- **Elasticsearch y Kibana**: Análisis y visualización de logs

## Monitorización
- **Prometheus, Grafana, cAdvisor, y Nagios** para salud y rendimiento del sistema

## Seguridad
- **Firewall**: Protección y regulación de tráfico
- **Fail2Ban**: Protección contra ataques de fuerza bruta

## Almacenamiento y Backup
- **NFS y PostgreSQL**: Soluciones de almacenamiento persistente

## Servicios de Aplicaciones
- **Apache Kafka**: Mensajería para microservicios
- **Nginx**: Servidor web para aplicación web

## Especificaciones del Servidor
| Característica         | Especificación                              |
|------------------------|---------------------------------------------|
| CPU                    | Intel Xeon X5650 (24 núcleos) @ 2.666GHz    |
| Memoria                | 1093MiB / 35904MiB                          |
| Almacenamiento         | Total: 3.27 TiB + 465.71 GiB                |
| Particiones            | Varias incluyendo raíz, intercambio, y home |
| Interfaces de Red      | Configuradas para diversas subredes y gestionadas por Open vSwitch |

## Interfaces de Red
- **enp3s0f0**: 192.168.0.24/24
- **enp3s0f1**: 192.168.0.25/24
- **enp4s0f0**: 192.168.0.20/24
- **enp4s0f1**: 192.168.0.26/24
- **lo**: 127.0.0.1/8

## Terraform Configuration for Network
```terraform
resource "libvirt_network" "kube_network" {
  name      = "kube_network"
  mode      = "nat"
  addresses = ["10.17.3.0/24"]
}
