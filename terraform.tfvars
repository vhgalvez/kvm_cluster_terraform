# terraform.tfvars
base_image = "/var/lib/libvirt/images/flatcar_image/flatcar_image/flatcar_production_qemu_image.img"
vm_definitions = {
  "bootstrap1"     = { count = 1, cpus = 1, memory = 1024 },
  "master"        = { count = 3, cpus = 2, memory = 2048 },
  "worker"        = { count = 3, cpus = 2, memory = 2048 },
  "freeipa1"       = { count = 1, cpus = 1, memory = 1024 },
  "load_balancer1" = { count = 1, cpus = 1, memory = 1024 },
  "nfs1"           = { count = 1, cpus = 1, memory = 1024 },
  "postgresql1"    = { count = 1, cpus = 1, memory = 1024 },
  "bastion1"       = { count = 1, cpus = 1, memory = 1024 },
  "elasticsearch1" = { count = 1, cpus = 2, memory = 2048 },
  "kibana1"        = { count = 1, cpus = 1, memory = 1024 }
}
ssh_keys       = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC12buyvSC4RkTaGVTXAAtYL69qWEHg55J4cnLbsiV6adRwdE9HGO9rUUaeXHA9rQ73a7bKVgsFI4dSiKbSWwyooIOcARiq69uxKhSmTBXeJeZtWy9XjQ2wqMFjtJ2PuUCyKgAff1+8UjothcZhndEDRMPKrS29ANzMk47E5TD1Po/CKEVmmrdOAytxK/PMvg4gna2t3TAq3Qt+aGUf9dr3SRxO+KEgvahDZbSvVCEK2UF0SWct+m3VBHKI4kQ8rhpb+kXUWEhkR042f3OhE6W4wKEh7VumOJiZnq2NmnovSfSv4RFwr9cxHMyqo6Bq9SF2T3B1/rO6EMXdCh5amMYZ vhgalvez@gmail.com"]
cluster_name   = "flatcar"
cluster_domain = "example.com"



