#!/bin/bash

release_name="backend-project"
chart_path="backend-project-0.1.0.tgz"
values_file="./values.yaml"

echo "Choose an action:"
echo "1. Deploy"
echo "2. Delete"

read -p "Enter your choice (1/2): " choice

# https://kubernetes.github.io/ingress-nginx/deploy/#ovhcloud
# helm install nginx-ingress ingress-nginx/ingress-nginx -n kintaro-backend

if [ "$choice" == "1" ]; then
  # Package the Helm chart
  helm package .

  # Check if the release exists
  if helm status "$release_name" &>/dev/null; then
    echo "Upgrading existing Helm release: $release_name"
    helm upgrade "$release_name" "$chart_path" --values "$values_file"
  else
    echo "Creating a new Helm release: $release_name"
    #helm upgrade "$release_name" "$chart_path" --values "$values_file"
    helm install "$release_name" "$chart_path" --values "$values_file"
  fi
elif [ "$choice" == "2" ]; then
  if helm status "$release_name" &>/dev/null; then
    echo "Deleting existing Helm release: $release_name"
    helm uninstall "$release_name"
  else
    echo "Release does not exist. Nothing to delete."
  fi
else
  echo "Invalid choice. Please choose 1 to deploy or 2 to delete."
fi