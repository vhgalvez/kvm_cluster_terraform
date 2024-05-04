# Documento Técnico: Instalación de Rocky Linux y FreeIPA para Configuración de DNS

## Descarga e Instalación de Rocky Linux

Primero, descarga la imagen ISO de Rocky Linux desde el sitio oficial:

```bash
mkdir -p /home/$USER/opt/isos
wget -P /home/$USER/opt/isos https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.3-x86_64-minimal.iso
```

A continuación, instala Rocky Linux en una máquina virtual:

```bash
sudo virt-install \
    --name RockyLinuxDNS \
    --memory 2048 \
    --vcpus 2 \
    --os-type linux \
    --os-variant generic \
    --disk path=/var/lib/libvirt/images/RockyLinuxDNS.qcow2,size=20 \
    --cdrom /home/$USER/opt/isos/Rocky-9.3-x86_64-minimal.iso \
    --network network=default,model=virtio \
    --graphics vnc,listen=0.0.0.0 \
    --noautoconsole
```

Para conectarte via VNC:

```bash
sudo virsh vncdisplay RockyLinuxDNS
```

## Instalación de FreeIPA

Una vez configurado el nombre de host y la resolución DNS, procede con la instalación de FreeIPA:

```bash
sudo yum install -y ipa-server ipa-server-dns
sudo ipa-server-install
```

Sigue las instrucciones en pantalla para completar la configuración de FreeIPA, incluyendo dominio y realm.

## Configuración del Servidor DNS en FreeIPA

1. Establece el nombre de host de FreeIPA:

```bash
    hostnamectl set-hostname ipa.example.com
```

2. Edita el archivo /etc/hosts para agregar la dirección IP y el hostname de tu servidor FreeIPA:

```bash
echo "192.168.120.10 ipa.example.com ipa" | sudo tee -a /etc/hosts
```

3. Configura y verifica el DNS en FreeIPA
Instala y configura el DNS durante la instalación de FreeIPA y verifica utilizando comandos como `dig` o `nslookup`.

Esta documentación técnica detalla los pasos para establecer un servidor de DNS usando Rocky Linux y FreeIPA, proporcionando una base sólida para servicios de red internos.
