#./pull-images.sh

#sudo chmod -R 700 k8s/kind/static/jira_data
#sudo chmod -R 700 k8s/kind/static/postgresqldata

./k8s/kind/kind create cluster --config k8s/kind/extra-mounts.yaml --image kindest/node:v1.24.0
kubectl config use-context kind-kind

kubectl create namespace selenium-grid
kubectl create namespace jenkins
kubectl create namespace jira
kubectl create namespace allure-testops
kubectl create -f k8s/selenium/
kubectl create -f k8s/jenkins/
kubectl create -f k8s/jira/jira-postgre

kubectl -n jira rollout status deployment postgre
kubectl create -f k8s/jira/

helm repo add qameta https://dl.qameta.io/artifactory/helm
helm repo update
helm upgrade -n allure-testops --install allure-testops qameta/allure-testops -f k8s/allure-testops/values.yaml

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl -n selenium-grid rollout status deployment selenium-router
kubectl -n jenkins rollout status deployment jenkins
kubectl -n jira rollout status deployment jira
kubectl -n selenium-grid port-forward service/selenium-router 4444:4444 >/dev/null 2>&1 &
kubectl -n jenkins port-forward service/jenkins 8080:8080 >/dev/null 2>&1 &
kubectl -n jira port-forward service/jira 8081:8080 >/dev/null 2>&1 &
