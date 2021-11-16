log_level = "DEBUG"

port = 8558

syslog {}

buffer_period {
  enabled = true
  min = "5s"
  max = "20s"
}


consul {
  address = ""
}

driver "terraform" {
  # version = "0.14.0"
  # path = ""
  log = true
  persist_log = false
  working_dir = ""

  backend "consul" {
    gzip = true
  }

}


task {
 name        = "cts-dir"
 description = "Add all to boundary"
 source      = "./04-boundary-module"
 condition "services" {
   regexp = ".*"
 }
}
