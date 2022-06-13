resource "yandex_vpc_network" "netology" {
  name = "vpc-netology"
}

resource "yandex_vpc_subnet" "public" {
  name           = "subnet-public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
