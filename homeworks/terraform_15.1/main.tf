terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.75"
}

provider "yandex" {
  // указал настройки в переменных окружения YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

resource "yandex_vpc_network" "netology" {
  name = "vpc-netology"
}

resource "yandex_vpc_subnet" "public" {
  name           = "subnet-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "nat" {
  name = "nat-instance"
  zone = yandex_vpc_subnet.public.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"     # nat-instance-ubuntu
    }
  }

  network_interface {
    subnet_id   = yandex_vpc_subnet.public.id
    ip_address  = "192.168.10.254"
    nat         = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "vm-1" {
  name = "vm-1"
  zone = yandex_vpc_subnet.public.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv9uuo1"     # ubuntu-20-04-lts-v20220606
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_route_table" "rtb-private" {
  network_id = yandex_vpc_network.netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "private" {
  name           = "subnet-private"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.rtb-private.id
}

resource "yandex_compute_instance" "vm-2" {
  name = "vm-2"
  zone = yandex_vpc_subnet.private.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd87tirk5i8vitv9uuo1"     # ubuntu-20-04-lts-v20220606
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/netology/id_rsa.pub")}"
  }
}