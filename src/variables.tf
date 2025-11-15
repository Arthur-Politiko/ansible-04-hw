###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}

variable "vpc_sub_name" {
  type        = string
  default     = "sub-platform-web"
  description = "VPC subnet name"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "ssh-keygen -t ed25519"
}

variable "nat_enable" {
  type        = bool
  default     = true
  description = "NAT enable for subnet"
}

###vm vars

variable "project" {
  type        = string
  default     = "netology"
  description = "Project name"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "https://yandex.cloud/ru/docs/compute/concepts/vm-platforms"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "https://cloud.yandex.ru/docs/compute/concepts/images"
}

#**********************************************#
variable "vms" {
  type = list(object({  
    vm_name = string, cpu = number, ram = number, disk_volume = number, core_fraction = number, serial-port-enable = bool, nat_enable = bool}))
  default = [
    { vm_name = "clickhouse", cpu = "2", ram = "2", disk_volume = "10", core_fraction = "100", serial-port-enable = true, nat_enable = false  },
    { vm_name = "vector", cpu = "2", ram = "1", disk_volume = "15", core_fraction = "20", serial-port-enable = true, nat_enable = false  },
    { vm_name = "lighthouse", cpu = "2", ram = "1", disk_volume = "15", core_fraction = "20", serial-port-enable = true, nat_enable = false  },
    { vm_name = "jumphost", cpu = "2", ram = "1", disk_volume = "10", core_fraction = "5", serial-port-enable = true, nat_enable = true  }
  ]
  description = "List of VMs"
}
