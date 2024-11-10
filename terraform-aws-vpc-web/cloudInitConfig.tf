resource "cloudinit_config" "foobar" {
  gzip          = false
  base64_encode = false


  part {
    filename     = "cloud-config.yml"
    content_type = "text/cloud-config"

    content = file("${path.module}/files/cloud-config.yml")
  }
}