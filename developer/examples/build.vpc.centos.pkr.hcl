// packer {
//   required_plugins {
//     ibmcloud = {
//       version = ">=v2.1.0"
//       source = "github.com/IBM/ibmcloud"
//     }
//   }
// }

variable "ibm_api_key" {
  type    = string
  default = "${env("IBM_API_KEY")}"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "ibmcloud-vpc" "centos" {
  api_key = "${var.ibm_api_key}"
  region  = "au-syd"

  subnet_id         = "02h7-46a8b111-3530-4337-9c04-c78e03160869"
  resource_group_id = "f054d39a43ce4f51afff708510f271cb"
  security_group_id = ""

  // vsi_base_image_id = "r026-4e9a4dcc-15c7-4fac-b6ea-e24619059218"
  vsi_base_image_name = "ibm-centos-7-9-minimal-amd64-5"

  vsi_profile         = "bx2-2x8"
  vsi_interface       = "public"
  vsi_user_data_file  = ""

  image_name = "packer-${local.timestamp}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

build {
  sources = [
    "source.ibmcloud-vpc.centos"
  ]

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    inline = [
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure'",
      "echo 'Hello from IBM Cloud Packer Plugin - VPC Infrastructure' >> /hello.txt"
    ]
  }
}
