#!/bin/bash

infoMessage() {
  echo "$(tput setaf 4)$1$(tput sgr 0)"
}

#./pull-images.sh

#sudo chmod -R 777 k8s/kind/static/jira_data
#sudo chmod -R 700 k8s/kind/static/postgresqldata
infoMessage "Creating cluster"
./k8s/kind/kind create cluster --config k8s/kind/extra-mounts.yaml --image kindest/node:v1.24.0

infoMessage "Importing allure test ops private images"
unzip docker-images/allure-testops/allure-testops.zip -d docker-images/allure-testops/
./k8s/kind/kind load image-archive docker-images/allure-testops/allure-gateway-4.7.0.tar
./k8s/kind/kind load image-archive docker-images/allure-testops/allure-report-4.7.0.tar
./k8s/kind/kind load image-archive docker-images/allure-testops/allure-uaa-4.7.0.tar
rm docker-images/allure-testops/allure-*.tar

infoMessage "Setting kind-kind context"
kubectl config use-context kind-kind

infoMessage "Creating namespaces"
kubectl create namespace selenium-grid
kubectl create namespace jenkins
kubectl create namespace jira
kubectl create namespace allure-testops

infoMessage "Creating k8s resources"
kubectl create -f k8s/selenium/
kubectl create -f k8s/jenkins/
kubectl create -f k8s/jira/jira-postgre

infoMessage "Waiting postgre for jira rollout"
kubectl -n jira rollout status deployment postgre
kubectl create -f k8s/jira/

infoMessage "Creating kubernetes resources"
helm repo add qameta https://dl.qameta.io/artifactory/helm
helm repo update
helm upgrade -n allure-testops --install allure-testops qameta/allure-testops -f k8s/allure-testops/values.yaml

infoMessage "Waiting for services rollout"
kubectl -n selenium-grid rollout status deployment selenium-router
kubectl -n jenkins rollout status deployment jenkins
kubectl -n jira rollout status deployment jira

infoMessage "Port forwarding services"
kubectl -n selenium-grid port-forward service/selenium-router 4444:4444 >/dev/null 2>&1 &
kubectl -n jenkins port-forward service/jenkins 8080:8080 >/dev/null 2>&1 &
kubectl -n jira port-forward service/jira 8081:8080 >/dev/null 2>&1 &
kubectl -n allure-testops port-forward service/allure-testops-gateway 8082:8080 >/dev/null 2>&1 &
