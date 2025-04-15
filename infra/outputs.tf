output "nginx_endpoint" {
    value = "http://${upcloud_server.web.network_interface[0].ip_address}:80"
    description = "nginx endpoint"
}