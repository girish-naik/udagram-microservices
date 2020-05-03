#!/bin/sh
echo "Setting up files"
 sed -i "s/___INSERT_AWS_CREDENTIALS_FILE__BASE64____/$AWS_CREDENTIALS/g" aws-secret.yaml
 sed -i "s/___INSERT_POSTGRESS_USERNAME__BASE64___/${POSTGRESS_USERNAME}/g" env-secret.yaml
 sed -i "s/___INSERT_POSTGRESS_PASSWORD__BASE64___/${POSTGRESS_PASSWORD}/g" env-secret.yaml
 sed -i "s/___INSERT_AWS_BUCKET___/${AWS_BUCKET}/g" env-configmap.yaml
 sed -i "s/___INSERT_AWS_PROFILE___/${AWS_PROFILE}/g" env-configmap.yaml
 sed -i "s/___INSERT_AWS_REGION___/${AWS_REGION}/g" env-configmap.yaml
 sed -i "s/___INSERT_JWT_SECRET___/${JWT_SECRET}/g" env-configmap.yaml
 sed -i "s/___INSERT_POSTGRESS_DB___/${POSTGRESS_DB}/g" env-configmap.yaml
 sed -i "s/___INSERT_POSTGRESS_HOST___/${POSTGRESS_HOST}/g" env-configmap.yaml

echo "Deploying secrets"
kubectl delete secret env-secret
kubectl create -f env-secret.yaml
kubectl delete secret aws-secret
kubectl create -f aws-secret.yaml
echo "Deploying env"
kubectl delete configmap env-config 
kubectl create -f env-configmap.yaml
echo "Deploying feed"
kubectl apply -f backend-feed-deployment.yaml
kubectl apply -f backend-feed-service.yaml
echo "Deploying user"
kubectl apply -f backend-user-deployment.yaml
kubectl apply -f backend-user-service.yaml
echo "Deploying reverseproxy"
kubectl apply -f reverseproxy-deployment.yaml
kubectl apply -f reverseproxy-service.yaml
echo "Deploying frontend"
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
