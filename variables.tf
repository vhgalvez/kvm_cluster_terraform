# variables.tf
variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_count" {
  description = "Map of VM types and their quantities"
  type = map(object({
    count : number
    cpus : number
    memory : number
  }))
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_domain" {
  description = "Domain of the cluster"
  type        = string
}

variable "ssh_keys" {
  description = "SSH keys to inject into VMs"
  type        = list(string)
}
