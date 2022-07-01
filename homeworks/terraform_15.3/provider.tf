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
