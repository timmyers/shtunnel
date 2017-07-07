# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "f922e945980d2271ba4bfae1b2f245640080f03ea3668f3a3c92b398993ebb2d"
}

# Create a new SSH key
resource "digitalocean_ssh_key" "terraform" {
  name       = "Terraform"
  public_key = "${file("~/.ssh/public_github_id_rsa.pub")}"
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-16-04-x64"
  name   = "web"
  region = "sfo1"
  size   = "512mb"
  ssh_keys = ["${digitalocean_ssh_key.terraform.id}"]
}

resource "digitalocean_domain" "tmye-me" {
  name       = "tmye.me"
  ip_address = "${digitalocean_droplet.web.ipv4_address}"
}

resource "digitalocean_record" "shtunnel-tmye-me" {
  domain     = "${digitalocean_domain.tmye-me.name}"
  name       = "shtunnel"
  type       = "A"
  value      = "${digitalocean_droplet.web.ipv4_address}"
}

resource "digitalocean_record" "wildcard-shtunnel-tmye-me" {
  domain     = "${digitalocean_domain.tmye-me.name}"
  name       = "*.shtunnel"
  type       = "A"
  value      = "${digitalocean_droplet.web.ipv4_address}"
}

output "webip" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}
