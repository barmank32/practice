provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "centos" {
  family = "centos-7"
}

data "yandex_vpc_subnet" "zone-b" {
  name = "private-subnet"
}

data "yandex_vpc_subnet" "zone-a" {
  name = "privat-subnet-a-zone"
}

data "yandex_vpc_subnet" "zone-c" {
  name = "privat-subnet-c-zone"
}

data "yandex_iam_service_account" "deployer" {
  name = "barmank"
}

resource "yandex_compute_instance" "test" {
  name     = "test"
  hostname = "test"
  zone     = "ru-central1-b"

  labels = {
    hostname = "test"
  }

  platform_id = "standard-v2" # Intel Cascade Lake
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.id
      size     = 10
      type     = "network-hdd"
    }
  }

  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.zone-b.id
    nat       = true
  }

  metadata = {
    ssh-keys           = "${var.login_user}:${file(var.public_key_path)}"
    serial-port-enable = 1
  }

  connection {
    type  = "ssh"
    host  = self.network_interface.0.nat_ip_address
    user  = var.login_user
    agent = false
    # путь до приватного ключа
    private_key = file(var.privat_key_path)
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.login_user} -i '${self.network_interface.0.nat_ip_address},' --private-key ${var.public_key_path} ../ansible/firewall.yml"
  }

}

locals {
  names = [
    yandex_compute_instance.test.name,
  ]
  ips = [
    yandex_compute_instance.test.network_interface.0.nat_ip_address,
  ]
}

resource "local_file" "generate_inventory" {
  content = templatefile("inventory.tpl", {
    names = local.names,
    addrs = local.ips,
  })
  filename = "inventory"

  provisioner "local-exec" {
    command = "chmod a-x inventory"
  }

  provisioner "local-exec" {
    command = "cp -u inventory ../ansible/inventory"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "mv inventory inventory.backup"
    on_failure = continue
  }

  provisioner "local-exec" {
    command     = "ansible-galaxy install -r requirements.yml"
    working_dir = "../ansible"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook main.yml"
    working_dir = "../ansible"
  }
}
