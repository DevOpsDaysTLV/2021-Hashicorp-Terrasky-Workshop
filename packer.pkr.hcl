packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "devopsdays2021-hashicorp-terasky"
  ami_groups    = ["all"]
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "devops"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"

    inline = [
      "apt-get update",
      "apt-get install -y ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo  \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable \" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -",
      "apt-add-repository \"deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main\"",
      "curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -",
      "echo \"deb https://baltocdn.com/helm/stable/debian/ all main\" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list",
      "sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
      "echo \"deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "apt-get update",
      "apt-get install -y docker-ce docker-ce-cli containerd.io terraform consul vault boundary jq git cowsay kubectl helm",
      "docker pull devopsdaystlv/2021-hashicorp-terashy-workshop:amd64",
      "docker tag devopsdaystlv/2021-hashicorp-terashy-workshop:amd64 devopsdaystlv/2021-hashicorp-terashy-workshop"
    ]
  }
}
