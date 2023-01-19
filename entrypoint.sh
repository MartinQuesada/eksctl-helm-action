#!/bin/sh

#!/usr/bin/env bash

# Login to Kubernetes Cluster.
if [ -n "$CLUSTER_ROLE_ARN" ]; then
  aws eks \
    --region ${AWS_REGION} \
    update-kubeconfig --name ${CLUSTER_NAME} \
    --role-arn=${CLUSTER_ROLE_ARN}
else
  aws eks \
    --region ${AWS_REGION} \
    update-kubeconfig --name ${CLUSTER_NAME}
fi

if [ ! -z ${HELM_ECR_AWS_ACCOUNT_ID} ] && [ ! -z ${HELM_ECR_AWS_REGION} ]; then
  echo "Login AWS ECR repository ${HELM_ECR_AWS_ACCOUNT_ID}.dkr.ecr.${HELM_ECR_AWS_REGION}.amazonaws.com"
  aws ecr get-login-password \
    --region ${HELM_ECR_AWS_REGION} | helm registry login \
    --username AWS \
    --password-stdin ${HELM_ECR_AWS_ACCOUNT_ID}.dkr.ecr.${HELM_ECR_AWS_REGION}.amazonaws.com
fi

echo "running entrypoint command(s)"

response=$(sh -c "$INPUT_COMMAND")

echo "response=$response" >> $GITHUB_ENV
