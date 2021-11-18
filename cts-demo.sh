#!/bin/bash

########################
# include the magic
########################
. /usr/local/bin/demo-magic.sh
TYPE_SPEED=80
clear

#####hashicorp/consul-terraform-sync
pe 'ls -l'
pe 'cd 02-hcp'
pe 'ls -l'
pe 'export CONSUL_HTTP_TOKEN=$(terraform output consul_root_token_secret_id | tr -d "\"")'
pe 'export CONSUL_PRIVATE_ADDRESS=$(terraform output consul_private_endpoint| tr -d "\"")'

pe 'cd ../01-vpc'
pe "cat remote.tf"
[ ! -f remote.tf.bck ] && cp remote.tf remote.tf.bck
sed "s#\"\"#\"$TF_VAR_tfc_organization_name\"#g" remote.tf.bck > remote.tf
pe "cat remote.tf"
pe "terraform init"
pe 'export BOUNDARY_IP=$(terraform output --raw boundary_public_ip)'
[ ! -f ../04-boundary-module/main.tf ] && cp ../04-boundary-module/main.tf ../04-boundary-module/main.tf.bck
sed "s#http://:9200#http://${BOUNDARY_IP}:9200#g"  ../04-boundary-module/main.tf.bck > ../04-boundary-module/main.tf

cat > cts.hcl << EOF
consul {
  address = "${CONSUL_PRIVATE_ADDRESS}"
  token = "${CONSUL_HTTP_TOKEN}"
}

log_level = "DEBUG"

task {
  name = "example-task"
  description = "Writes the service name, id, and IP address to a file"
  source      = "./boundary-module"
#  source  = "mkam/hello/cts"
  providers = ["local"]
  condition "services" {
    regexp = ".*"
  }
  variable_files = []
}

driver "terraform" {
  backend "local" {
    path = "./terraform.tfstate"
  }
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

terraform_provider "local" {
}
EOF
pe 'cat cts.hcl'

pe 'kubectl create secret generic cts-config --from-file=./cts.hcl'
pe 'kubectl create secret generic boundary-module --from-file=../04-boundary-module'
p "Let's deploy terraform consul sync"
cat > cts.yaml <<EOF
---
apiVersion: v1
kind: Pod
metadata:
  name: cts
  labels:
    app: cts
spec:
  containers:
    - name: cts
      image: hashicorp/consul-terraform-sync
      args:
      - "-config-file"
      - "/etc/cts/cts.hcl"
      volumeMounts:
      - name: cts-config
        mountPath: "/etc/cts"
      - name: boundary-module
        mountPath: "/consul-terraform-sync/boundary-module"
  volumes:
  - name: cts-config
    secret:
      secretName: cts-config
  - name: boundary-module
    secret:
      secretName: boundary-module
EOF
pe 'cat cts.yaml'
pe 'kubectl apply -f cts.yaml'
pe 'kubectl get pods'
pe 'kubectl logs cts'
pe 'kubectl exec -it cts -- cat sync-tasks/example-task/services_greetings.txt'
