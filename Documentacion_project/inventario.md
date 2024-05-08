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

### Configuración de VLANs y Redes Virtuales

- **VLAN 101**: Bootstrap Node
- **VLAN 102**: Master Nodes
- **VLAN 103**: Worker Nodes
- **VLAN 104**: Bastion Node
- **VLAN 105**: NFS y PostgreSQL Nodes
- **VLAN 106**: Load Balancer Node
- **VLAN 107**: FreeIPA Node
