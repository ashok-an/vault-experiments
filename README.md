### Sources
1. https://learn.hashicorp.com/tutorials/vault/database-secrets
2. https://learn.hashicorp.com/tutorials/vault/application-integration

### Generate with consul-template
```
$ VAULT_TOKEN=root consul-template -template="config.yaml.tpl:config.yaml" -once

``` 

### Generate with consulenv
```
$ VAULT_TOKEN=root envconsul -upcase -secret database/creds/readonly ./app.sh

```
