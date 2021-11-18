#!/bin/bash

########################
# include the magic
########################
. /usr/local/bin/demo-magic.sh
TYPE_SPEED=80
clear

pe 'ls -l'
pe 'cd 02-hcp'
pe 'ls -l'
pe 'export CONSUL_HTTP_TOKEN=$(terraform output consul_root_token_secret_id | tr -d "\"")'

p "Open $(terraform output consul_public_endpoint) and use ${CONSUL_HTTP_TOKEN} token to login"

pe 'terraform output consul_ca_file | tr -d "\"" | base64 -d> ./ca.pem'
pe 'export KUBECONFIG=/tmp/kubeconfig'
pe "kubectl create secret generic \"consul-ca-cert\" --from-file='tls.crt=./ca.pem'"

pe 'terraform output consul_config_file | tr -d "\""| base64 -d | jq > client_config.json'
pe 'cat client_config.json'
pe 'kubectl create secret generic "consul-gossip-key" --from-literal="key=$(jq -r .encrypt client_config.json)"'

pe 'kubectl create secret generic "consul-bootstrap-token" --from-literal="token=${CONSUL_HTTP_TOKEN}"'
# read about bootstrap ACL
#https://learn.hashicorp.com/tutorials/consul/access-control-setup-production?in=consul/security

pe 'helm repo add hashicorp https://helm.releases.hashicorp.com && helm repo update'

pe 'export DATACENTER=$(jq -r .datacenter client_config.json)'
pe 'export RETRY_JOIN=$(jq -r --compact-output .retry_join client_config.json)'
pe 'export CONSUL_HTTP_ADDR=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"$(kubectl config current-context)\")].cluster.server}")'
pe 'echo $DATACENTER && \
  echo $RETRY_JOIN && \
  echo $CONSUL_HTTP_ADDR'

cat > config.yaml << EOF
global:
  name: consul
  enabled: false
  datacenter: ${DATACENTER}
  acls:
    manageSystemACLs: true
    bootstrapToken:
      secretName: consul-bootstrap-token
      secretKey: token
  gossipEncryption:
    secretName: consul-gossip-key
    secretKey: key
  tls:
    enabled: true
    enableAutoEncrypt: true
    caCert:
      secretName: consul-ca-cert
      secretKey: tls.crt
externalServers:
  enabled: true
  hosts: ${RETRY_JOIN}
  httpsPort: 443
  useSystemRoots: true
  k8sAuthMethodHost: ${CONSUL_HTTP_ADDR}
client:
  enabled: true
  join: ${RETRY_JOIN}
connectInject:
  enabled: false
controller:
  enabled: true
ingressGateways:
  enabled: false
syncCatalog:
  enabled: true
EOF

pe 'cat config.yaml'
pe 'helm install --wait consul -f config.yaml hashicorp/consul --version "0.32.1" --set global.image=hashicorp/consul-enterprise:1.10.1-ent'

pe 'kubectl get pods'

p "Open $(terraform output consul_public_endpoint) and use ${CONSUL_HTTP_TOKEN} token to login"
pe 'kubectl get svc'

