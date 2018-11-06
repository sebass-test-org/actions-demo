#!/bin/sh

set -e

DEPLOYMENT_ID=`curl -H "Authorization: token ${GITHUB_TOKEN}" -d '{"ref": "master", "environment": "staging", "required_contexts": []}' https://api.github.com/repos/${GITHUB_REPOSITORY}/deployments -s | jq -r '.id'`

echo $DEPLOYMENT_ID

echo "Login"
az login --service-principal --username "${SERVICE_PRINCIPAL}" --password "${SERVICE_PASS}" --tenant "${TENANT_ID}"

echo "Creating resource group ${APPID}-group"
az group create -n ${APPID}-group -l westcentralus

echo "Creating app service plan ${APPID}-plan"
az appservice plan create -g ${APPID}-group -n ${APPID}-plan --sku FREE

echo "Creating webapp ${APPID}"

DEPLOYMENT_URL=`az webapp create -g ${APPID}-group -p ${APPID}-plan -n ${APPID} --deployment-local-git | jq -r '.hostNames[0]'`
echo "http://${DEPLOYMENT_URL}"

echo "Getting username/password for deployment"
DEPLOYUSER=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userName' -o tsv`
DEPLOYPASS=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userPWD' -o tsv`

GIT_URL="https://${DEPLOYUSER}:${DEPLOYPASS}@${APPID}.scm.azurewebsites.net/${APPID}.git"

git remote add azure https://${DEPLOYUSER}:${DEPLOYPASS}@${APPID}.scm.azurewebsites.net/${APPID}.git

git push azure master -f

curl -H "Authorization: token ${GITHUB_TOKEN}" -H "Accept: application/vnd.github.full+json" -d '{"state": "success", "environment_url": "http://${DEPLOYMENT_URL}"}' https://api.github.com/repos/${GITHUB_REPOSITORY}/deployments/${DEPLOYMENT_ID}/statuses -s
