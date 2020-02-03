# Uncomment this to have Agent run once (e.g. when running as an initContainer)
exit_after_auth = false
pid_file = "/home/vault/pidfile"

auto_auth {
    method "approle" {
      mount_path = "auth/approle"
      config = {
        role_id_file_path = "/approle/roleid"
        secret_id_file_path = "/approle/secretid"
        remove_secret_id_file_after_reading = false
      }
    }

    sink "file" {
        config = {
            path = "/home/vault/.vault-token"
        }
    }
}

template {
  destination = "/etc/secrets/index.html"
  contents = <<EOH
  <html>
  <body>
  <p>Some secrets:</p>
  {{- with secret "secrets1/myapp/config" }}
  <ul>
  <li><pre>username: {{ .Data.username }}</pre></li>
  <li><pre>password: {{ .Data.password }}</pre></li>
  </ul>
  {{ end }}
  </body>
  </html>
  EOH
}
