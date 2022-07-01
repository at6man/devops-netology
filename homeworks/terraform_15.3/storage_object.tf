resource "yandex_storage_object" "test-password" {
  bucket = yandex_storage_bucket.bucket-1.id
  key    = "test-password.txt"
  source = "test-password.txt"
  acl    = "public-read"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  depends_on = [
    yandex_resourcemanager_folder_iam_member.kms-keys-admin
  ]
}