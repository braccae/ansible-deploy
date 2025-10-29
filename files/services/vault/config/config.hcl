ui            = true
cluster_addr  = "https://0.0.0.0:8201"
api_addr      = "https://0.0.0.0:8200"
disable_mlock = true

storage "postgresql" {
  connection_url = "postgres://vault:secret123!@127.0.0.1:5432/vault?sslmode=disable"
  max_idle_connections = 16
  ha_enabled = false
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/path/to/full-chain.pem"
  tls_key_file  = "/path/to/private-key.pem"
}

telemetry {
  statsite_address = "127.0.0.1:8125"
  disable_hostname = true
}
