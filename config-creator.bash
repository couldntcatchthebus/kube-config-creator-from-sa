# your server name goes here
server=https://<server.hcp.westeurope.azmk8s.io:443>
# the name of the secret containing the service account token goes here
name=<default-user-token>

ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' | base64 -d)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' | base64 -d)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: ${namespace}
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > user.kubeconfig