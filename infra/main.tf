resource "upcloud_server" "web" {
    hostname = "my-docker-server"
    zone = "de-fra1"
    plan = "1xCPU-1GB"
    metadata = true

    template {
        storage = "Ubuntu Server 22.04 LTS (Jammy Jellyfish)"
        size = 10
    }

    network_interface {
        type = "public"
    }

    login {
        user = "nonroot"
        keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQUeGbsD5UKgiIbKI3OsfWXAtRc/4c6FH00BDDSzvX5 gabuzo@192-168-1-121.tpgi.com.au"
        ]
    }

    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = "nonroot"
            private_key = file("~/keys/id_ed25519")
            host = self.network_interface[0].ip_address
        }

        inline = [
            "sudo apt update -y",
      "sudo apt install -y docker.io git",
      "sudo usermod -aG docker nonroot && sudo systemctl restart docker",
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "ssh-keyscan github.com >> ~/.ssh/known_hosts",
      "git clone https://github.com/dyordsabuzo/nginx-node-redis.git",
      "cd nginx-node-redis && sudo -u nonroot sg docker -c \"docker-compose -f compose.yml up -d\""
        ]
    }
}