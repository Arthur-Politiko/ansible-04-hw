resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "sub" {
  name           = var.vpc_sub_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu-2004-lts" {
  family = var.vm_image_family
}

resource "yandex_compute_instance" "vms" {
  # toset не сработает, внутри объект
  # прийдётся использовать for. vm.vm_name => vm создаём map, где ключ vm_name
  # то есть после работы for_each получаем объект вида:
  #   "main"     = { vm_name = "main", ...
  #   "replica"  = { vm_name = "replica", ...
  for_each = { for vm in var.vms : vm.vm_name => vm }
  #for_each = [ for k, v in var.db_vms : v ]

  name = each.value.vm_name
  hostname = each.value.vm_name
  
  platform_id = var.vm_platform_id
  zone = var.default_zone

  resources {
    cores = each.value.cpu   # 
    memory = each.value.ram  #
    core_fraction = each.value.core_fraction #
  }
  metadata = {
    serial-port-enable =  each.value.serial-port-enable
    #ssh-keys = "${var.default_metadata.user}:${file(var.default_metadata.filepath)}"
    ssh-keys = "ubuntu:${file(var.vms_ssh_root_key)}"
  }
  boot_disk {
    initialize_params {
      # https://yandex.cloud/ru/docs/terraform/data-sources/compute_instance#nested-schema-for6
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      size     = each.value.disk_volume  # GB
      #type     = "network-hdd"  # "network-ssd"
    }
  }
  scheduling_policy {
    # конфигурация политики планирования в контексте Yandex Cloud
    # preemptible - прерывание виртуальной машины
    preemptible = true #var.default_scheduling_policy_flag
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.sub.id
    #nat       = each.value.nat_enable
    nat       = true
    # https://terraform-provider.yandexcloud.net/resources/compute_instance
    # security_group_ids = [yandex_vpc_security_group.strict1.id]
  }
}

# locals {
#   depends_on = [ yandex_compute_instance.vms ]
#   # hcvms = {
#   #   webservers = length(yandex_compute_instance.web) == 0 ? {} : { for i in yandex_compute_instance.web: i.name => i},
#   #   databases = length(yandex_compute_instance.db) == 0 ? {} : {for k, v in yandex_compute_instance.db: k => v },
#   #   storage = length(yandex_compute_instance.storage.*) == 0 ? {} : { for i in yandex_compute_instance.storage.*: i.name => i},
#   # }
#   hcvms = { for vm in var.vms : vm.vm_name => vm }
#   #all_vms = flatten(local.hcvms)
# }

 resource "local_file" "hc_inventory" {
   depends_on = [ yandex_compute_instance.vms ]

   content = templatefile("hc_host.tftpl",
     { root = [ for k in yandex_compute_instance.vms : { "hostname" = k.hostname, "ip_address" = k.network_interface[0].ip_address, "nat_ip_address" = k.network_interface[0].nat_ip_address } ] 
       nat_ip_address = yandex_compute_instance.vms["jumphost"].network_interface[0].nat_ip_address
     }
   )
   filename = "../bootstrap/inventory/prod.yml"
 }

