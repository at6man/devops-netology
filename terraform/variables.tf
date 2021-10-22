locals {
    server_instance_type_map = {
        stage = "t3.micro"
        prod = "t3.large"
    }
    server_instance_count_map = {
        stage = 1
        prod = 2
    }
}