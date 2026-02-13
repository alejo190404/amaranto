#!/usr/bin/env bash

set -euo pipefail

echo "WARNING: This script is intended for LOCAL development only. Do NOT run in shared or production clusters."

echo "Pointing Docker CLI to Minikube's Docker daemon..."
eval "$(minikube docker-env)"

echo "Enabling Ingress addon..."
minikube addons enable ingress

echo "Building Docker image nutrition-ms:latest..."
docker build -t nutrition-ms:latest -f ../deployment/Dockerfile ..

echo "Applying Kubernetes manifests..."
kubectl apply -f ../deployment/kubernetes/configmap.yaml
kubectl apply -f ../deployment/kubernetes/deployment.yaml
kubectl apply -f ../deployment/kubernetes/service.yaml

sleep 30

echo "Starting kubectl port-forward to expose the service on localhost:8000..."
echo "Press Ctrl+C to stop port-forwarding when you're done."
kubectl port-forward svc/nutrition-ms-service 8000:81

