#!/bin/bash
# test-charts.sh

set -e

# Install prerequisites
helm plugin install https://github.com/quintush/helm-unittest

# Run helm lint
echo "Running helm lint..."
helm lint charts/infrastructure-services
helm lint charts/laravel-app

# Run unit tests
echo "Running unit tests..."
helm unittest charts/infrastructure-services
helm unittest charts/laravel-app

# Create test cluster
echo "Creating test cluster..."
kind create cluster --name helm-testing

# Install cert-manager
echo "Installing cert-manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml
kubectl wait --for=condition=Ready pods -n cert-manager --all --timeout=300s

# Install charts
echo "Installing charts..."
helm install infrastructure-test ./charts/infrastructure-services \
  -f charts/infrastructure-services/values-staging.yaml \
  -n infrastructure-staging --create-namespace

# Wait for deployments
echo "Waiting for deployments..."
kubectl wait --for=condition=Available deployments --all -n infrastructure-staging --timeout=300s

# Run tests
echo "Running helm test..."
helm test infrastructure-test -n infrastructure-staging

# Cleanup
echo "Cleaning up..."
kind delete cluster --name helm-testing
