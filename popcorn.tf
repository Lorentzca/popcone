# set variables
variable "do_token" {
  default = "パーソナルアクセストークン"
}
variable "keys" {
  default = 鍵ID
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create a new Web droplet in the sgp1 region
resource "digitalocean_droplet" "wp" {
  size = "512mb"
  image = "centos-6-5-x64"
  name = "popcorn"
  region = "sgp1"
  ssh_keys = [${var.keys}]

  provisioner "local-exec" {
    command = "echo '[popcorn]' >> ./hosts && echo '${digitalocean_droplet.wp.ipv4_address}' >> ./hosts && ansible-playbook -i hosts popcorn.yml --user=root --private-key=~/.ssh/id_rsa"
    connection {
      user = "root"
      type = "ssh"
      key_file = "~/.ssh/id_rsa"
      timeout = "2m"
    }
  }
}

output "ip" {
    value = "${digitalocean_droplet.wp.ipv4_address}"
}
