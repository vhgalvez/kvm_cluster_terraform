# variables.tf
variable "base_image" {
  description = "Path to the base VM image"
  type        = string
}

variable "vm_definitions" {
  type = map(object({
    count  = number
    cpus   = number
    memory = number
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
variable "machines" {
  description = "List of machines to create"
  type        = list(string)
  default     = [] # This will be dynamically populated in the locals or directly in terraform.tfvars if required
}
