# variables.tf
variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_definitions" {
  description = "Definitions of virtual machines including CPU and memory configuration"
  type = map(object({
    cpus   = number
    memory = number
  }))
}

variable "ssh_keys" {
  description = "List of SSH keys to inject into VMs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_domain" {
  description = "Domain name of the cluster"
  type        = string
}
variable "vm_definitions" {
  description = "Definitions of virtual machines including CPU, memory, and static IP configuration"
  type = map(object({
    cpus   = number
    memory = number
    ip     = string # Ensure this line is added
  }))
}
