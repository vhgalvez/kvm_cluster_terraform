### Hardware del Servidor

- **Modelo**: ProLiant DL380 G7
- **CPU**: Intel Xeon X5650 (24 cores) @ 2.666GHz
- **GPU**: AMD ATI 01:03.0 ES1000
- **Memoria**: 1093MiB / 35904MiB
- **Almacenamiento**:
  - Disco Duro Principal: 1.5TB
  - Disco Duro Secundario: 3.0TB

### Sistemas Operativos y Virtualización

- **Rocky Linux 9.3 (Blue Onyx)**
- **rocky linux minimal**
- **KVM con Libvirt**
- **Flatcar Container Linux**

### Configuración de Red

- **Open vSwitch**: Gestión de redes virtuales y VLANs
- **VPN con WireGuard**
- **IP Pública**
- **DHCP en KVM**
- **Firewall**
- **Modo NAT y Bridge**
- **VLANs**: 101, 102, 103, 104, 105, 106, 107
- **Switch y Router:** Facilitan la comunicación y conectividad del clúster.

### Máquinas Virtuales y Roles

- **Bastion Node**: Punto de acceso seguro, modo de red Bridge, interfaz enp3s0f1
- **Bootstrap Node**: Inicializa el clúster
- **Master Nodes**: Gestión del clúster
- **Worker Nodes**: Ejecución de aplicaciones
- **FreeIPA Node**: Gestión de identidades
- **Load Balancer Node**
- **NFS Node**: Almacenamiento de archivos
- **PostgreSQL Node**: Gestión de bases de datos
- **Elasticsearch Node**: Análisis de logs
- **Kibana Node**: Visualización de datos

### Interfaces de Red Identificadas

- **enp3s0f0**: 192.168.0.24
- **enp3s0f1**: 192.168.0.25 (utilizada para Bridge en Bastion Node)
- **enp4s0f0**: 192.168.0.20
- **enp4s0f1**: 192.168.0.26
- **lo (Loopback)**: 127.0.0.1

### Automatización y Orquestación

- **Terraform**: Automatización de infraestructura
- **Ansible**: Configuración y manejo de operaciones

### Análisis y Visualización de Datos

- **Elasticsearch**
- **Kibana**
- **Prometheus y Grafana:** Herramientas para el monitoreo y la visualización de métricas del clúster.


### Configuración de VLANs y Redes Virtuales

- **VLAN 101**: Bootstrap Node
- **VLAN 102**: Master Nodes
- **VLAN 103**: Worker Nodes
- **VLAN 104**: Bastion Node
- **VLAN 105**: NFS y PostgreSQL Nodes
- **VLAN 106**: Load Balancer Node
- **VLAN 107**: FreeIPA Node

### Seguridad y Protección

**Firewall y Fail2Ban:** Protección contra accesos no autorizados y ataques.
**DNS y FreeIPA:** Gestión centralizada de autenticación y políticas de seguridad.

### Servicios de Aplicaciones

**Nginx:** Servidor web y proxy inverso para aplicaciones web.
**Apache Kafka:** Plataforma de mensajería utilizada para la comunicación entre microservicios.


### Especificaciones de Almacenamiento y Memoria
- **Configuración de Disco y Particiones**:
  - **/dev/sda**: 3.27 TiB
  - **/dev/sdb**: 465.71 GiB
- **Particiones**:
  - **/dev/sda1**: Sistema
  - **/dev/sda2**: 2 GB Linux Filesystem
  - **/dev/sda3**: ~2.89 TiB Linux Filesystem
- **Uso de Memoria**:
  - **Total Memory**: 35GiB
  - **Free Memory**: 33GiB
  - **Swap**: 17GiB
- **Uso del Filesystem**:
  - **/dev/mapper/rl-root**: 100G (7.5G usado)
  - **/dev/sda2**: 1014M (718M usado)
  - **/dev/mapper/rl-home**: 3.0T (25G usado)