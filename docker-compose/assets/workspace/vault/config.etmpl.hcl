storage "raft" {
  path    = "/var/vault"
  node_id = "$NODE"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://$NODE:8200"
cluster_addr = "https://$NODE:8201"

ui = true
