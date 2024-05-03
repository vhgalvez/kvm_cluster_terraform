# terraform.tfvars
base_image = "/var/lib/libvirt/images/flatcar_image/flatcar_image/flatcar_production_qemu_image.img"
vm_definitions = {
  "bootstrap1"     = { cpus = 1, memory = 1024, ip = "10.17.3.10" },
  "master1"        = { cpus = 2, memory = 2048, ip = "10.17.3.11" },
  "master2"        = { cpus = 2, memory = 2048, ip = "10.17.3.12" },
  "master3"        = { cpus = 2, memory = 2048, ip = "10.17.3.13" },
  "worker1"        = { cpus = 2, memory = 2048, ip = "10.17.3.14" },
  "worker2"        = { cpus = 2, memory = 2048, ip = "10.17.3.15" },
  "worker3"        = { cpus = 2, memory = 2048, ip = "10.17.3.16" },
  "freeipa1"       = { cpus = 1, memory = 1024, ip = "10.17.3.17" },
  "load_balancer1" = { cpus = 1, memory = 1024, ip = "10.17.3.18" },
  "nfs1"           = { cpus = 1, memory = 1024, ip = "10.17.3.19" },
  "postgresql1"    = { cpus = 1, memory = 1024, ip = "10.17.3.20" },
  "bastion1"       = { cpus = 1, memory = 1024, ip = "10.17.3.21" },
  "elasticsearch1" = { cpus = 2, memory = 2048, ip = "10.17.3.22" },
  "kibana1"        = { cpus = 1, memory = 1024, ip = "10.17.3.23" }
}
ssh_keys       = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC12buyvSC4RkTaGVTXAAtYL69qWEHg55J4cnLbsiV6adRwdE9HGO9rUUaeXHA9rQ73a7bKVgsFI4dSiKbSWwyooIOcARiq69uxKhSmTBXeJeZtWy9XjQ2wqMFjtJ2PuUCyKgAff1+8UjothcZhndEDRMPKrS29ANzMk47E5TD1Po/CKEVmmrdOAytxK/PMvg4gna2t3TAq3Qt+aGUf9dr3SRxO+KEgvahDZbSvVCEK2UF0SWct+m3VBHKI4kQ8rhpb+kXUWEhkR042f3OhE6W4wKEh7VumOJiZnq2NmnovSfSv4RFwr9cxHMyqo6Bq9SF2T3B1/rO6EMXdCh5amMYZ vhgalvez@gmail.com"]
cluster_name   = "flatcar"
cluster_domain = "example.com"