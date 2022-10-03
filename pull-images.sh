echo "Pulling mandatory docker images @ docker.io"

#KIND
KIND_NODE_VERSION=v1.24.0

docker pull kindest/node:$KIND_NODE_VERSION
#SELENIUM
SELENIUM_VERSION=4.5.0

docker pull selenium/node-chrome:$SELENIUM_VERSION
docker pull selenium/node-edge:$SELENIUM_VERSION
docker pull selenium/node-firefox:$SELENIUM_VERSION
docker pull selenium/distributor:$SELENIUM_VERSION
docker pull selenium/event-bus:$SELENIUM_VERSION
docker pull selenium/router:$SELENIUM_VERSION
docker pull selenium/session-queue:$SELENIUM_VERSION
docker pull selenium/sessions:$SELENIUM_VERSION

#JIRA
JIRA_VERSION=8.5.4
docker pull atlassian/jira-software:$JIRA_VERSION
docker pull postgres:9.6-alpine

#JENKINS
docker pull jenkins/jenkins:latest
docker pull jenkins/jnlp-agent-maven:jdk11

#SONARQUBE
docker pull sonarqube:community

