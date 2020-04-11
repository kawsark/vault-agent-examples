# vault-agent-examles
A Repo that demonstrates using the Vault Agent with Kubernetes and AppRole Auth methods. Both Auth methods are shown with the Vault Agent injector and without. Please skip to the appropriate section in the Readme below.
1. Kubernetes Auth Method
    1. Without the Vault Agent injector
    1. With the Vault Agent injector
1. AppRole Auth Method
    1. Without the Vault Agent injector
    1. With the Vault Agent injector

## Pre-requisites
Please use the steps below for Vault K/V setup for the application we will deploy.
```
vault secrets enable -path=secret/ -version=2 kv
vault policy write myapp-kv-ro - <<EOF
# If working with K/V v1
path "secret/myapp/*" {
    capabilities = ["read", "list"]
}

# If working with K/V v2
path "secret/data/myapp/*" {
    capabilities = ["read", "list"]
}
EOF

vault kv put secret/myapp/config username='appuser' password='suP3rsec(et!' ttl='30s'
```
## Kubernetes Auth method
- Setup and configure the Kubernetes Auth method.

### Without the Vault Agent injector

### With the Vault Agent injector
Ensure the Vault Agent injector pod is running as shown in the example below.
- Pending


## AppRole Auth method
- Setup and configure the AppRole Auth method.
```
vault auth enable approle
vault write auth/approle/role/my-role \
    secret_id_ttl=24h \
    secret_id_num_uses=100 \
    token_num_uses=10 \
    token_ttl=24h \
    token_max_ttl=48h \
    policies="myapp-kv-ro"

vault read -format=json auth/approle/role/my-role/role-id > role.json
vault write -format=json -f auth/approle/role/my-role/secret-id > secretid.json
ROLE_ID="$(cat role.json | jq -r .data.role_id )" && echo $ROLE_ID > roleid
SECRET_ID="$(cat secretid.json | jq -r .data.secret_id )" && echo $SECRET_ID > secretid
kubectl create configmap approle --from-file=roleid --from-file=secretid
kubectl describe configmap approle
```

Now proceed onto deploy the sample application using of the methods below

### Without the Vault Agent injector
- Mount the included config maps as below:
```
mkdir config-k8s/ && cp vault-agent-config-approle-*.hcl config-k8s/
kubectl create configmap example-vault-agent-config --from-file=./configs-k8s/
kubectl create -f example-k8s-spec-approle.yml
kubectl logs vault-agent-example vault-agent-sidecar
```
- Test the application by performing a port-forward:
```
kubectl port-forward pod/vault-agent-example 30080:80
open browser to http://localhost:30080/
```
- Test the application by performing a port-forward:
```
vault kv put secrets1/myapp/config username='appuser' password='newsecret' ttl='30s'
open browser to http://localhost:30080/
```

### With the Vault Agent injector
Ensure the Vault Agent injector pod is running as shown in the example below.
- Pending
