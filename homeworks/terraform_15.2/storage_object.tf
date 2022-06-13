resource "yandex_storage_object" "image-1" {
  bucket = yandex_storage_bucket.bucket-1.id
  key    = "homework-image.jpg"
  source = "homework-15.2.jpg"
  acl    = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}