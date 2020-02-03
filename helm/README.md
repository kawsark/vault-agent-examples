# Ensure that the correct context is selected
kubectl config get-contexts

# Install helm
cat <<EOF > rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-clusterrolebinding
subjects:
- kind: ServiceAccount
  name: tiller
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: ""
EOF
kubectl apply -f rbac.yaml
helm init --service-account tiller

helm install --name vault-k8s -f vaultk8s.values.yaml https://github.com/hashicorp/vault-helm.git

# Move to Initialize and unseal

# To update later, use the command as below
helm upgrade vault-dockerk8s -f dockerk8s.values.yaml https://github.com/hashicorp/vault-helm.git
