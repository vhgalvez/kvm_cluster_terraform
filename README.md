# kvm_cluster_terraform
 kvm_cluster_terraform


# Eliminar las VMs
chmod +x eliminar_vms.sh.

./eliminar_vms.sh


./eliminar_vms.sh



sysctl vm.overcommit_memory

Si es necesario, cambia el valor a 1 para permitir el sobrecompromiso de memoria2:

sysctl vm.overcommit_memory=1


Verificar el Estado del Servicio Libvirt:
Comprueba el estado del servicio para asegurarte de que está activo y corriendo:
bash
Copy code
sudo systemctl status libvirtd
Reiniciar el Servicio Libvirt:
A veces, un simple reinicio del servicio puede solucionar problemas transitorios:
bash
Copy code
sudo systemctl restart libvirtd
Revisar la Configuración de Registro (Logging):
Verifica si la configuración de libvirt está ajustada para registrar los detalles necesarios. Puedes revisar el archivo de configuración de libvirt (usualmente ubicado en /etc/libvirt/libvirtd.conf) y buscar las siguientes líneas:
conf
Copy code
log_level = 3
log_outputs = "1:file:/var/log/libvirt/libvirtd.log"
Asegúrate de que el registro esté activado y configurado para escribir en un archivo. Si haces cambios, reinicia el servicio para aplicarlos.
Verificar Logs Alternativos:
Si los registros del servicio no están disponibles a través de journalctl, intenta revisar directamente los archivos de registro que podrían estar en /var/log/libvirt/ o en la ubicación especificada en la configuración:
bash
Copy code
sudo cat /var/log/libvirt/libvirtd.log
Buscar Errores en Logs del Sistema:
Además de los logs de libvirt, revisa los logs generales del sistema para cualquier mensaje relacionado con libvirt o QEMU:
bash
Copy code
sudo dmesg | grep -i qemu
sudo grep -i qemu /var/log/syslog  # En sistemas que usen syslog


/usr/libexec/qemu-kvm -cpu help


Parece que has abierto el archivo /etc/sysctl.conf con el comando nano, pero no has agregado la línea necesaria para aumentar el límite del espacio de direcciones físicas.

Aquí tienes los pasos nuevamente:

Abre el archivo /etc/sysctl.conf con el editor de texto nano:
bash
Copy code
sudo nano /etc/sysctl.conf
Agrega la siguiente línea al final del archivo:
Copy code
vm.max_map_count = 262144
Esto aumentará el límite del espacio de direcciones físicas.
Guarda los cambios y cierra el archivo.
Una vez hecho esto, puedes verificar que la línea se haya agregado correctamente ejecutando:

bash
Copy code
sudo cat /etc/sysctl.conf
Si la línea está presente, procede a aplicar los cambios ejecutando:

css
Copy code
sudo sysctl -p