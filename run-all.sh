#SELENIUM
docker pull kindest/node:v1.24.0
docker pull selenium/node-chrome:4.4.0-20220812
docker pull selenium/node-edge:4.4.0-20220812
docker pull selenium/node-firefox:4.4.0-20220812
docker pull selenium/distributor:4.4.0-20220812
docker pull selenium/event-bus:4.4.0-20220812
docker pull selenium/router:4.4.0-20220812
docker pull selenium/session-queue:4.4.0-20220812
docker pull selenium/sessions:4.4.0-20220812

#JIRA
docker pull atlassian/jira-software:8.5.4

#JENKINS
docker pull jenkins/jenkins:latest
docker pull jenkins/jnlp-agent-maven:jdk11

#SONARQUBE
docker pull sonarqube:community
docker pull postgres:9.6
docker pull postgres:12

./k8s/kind/kind create cluster --config k8s/kind/extra-mounts.yaml --image kindest/node:v1.24.0
kubectl config use-context kind-kind
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl create namespace selenium-grid
kubectl create namespace jenkins
kubectl create namespace jenkins-builds
kubectl create -f k8s/selenium/
kubectl create -f k8s/jenkins/

kubectl -n selenium-grid rollout status deployment selenium-router
kubectl -n jenkins rollout status deployment jenkins
kubectl -n selenium-grid port-forward service/selenium-router 4444:4444 >/dev/null 2>&1 &
kubectl -n jenkins port-forward service/jenkins 8080:8080 >/dev/null 2>&1 &
