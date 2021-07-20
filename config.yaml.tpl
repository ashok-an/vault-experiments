---
{{- with secret "database/creds/readonly" }}
  username: "{{ .Data.username }}"
  password: "{{ .Data.password }}"
  database: "devxdemo-db"
{{- end }}


