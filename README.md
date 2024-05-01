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
