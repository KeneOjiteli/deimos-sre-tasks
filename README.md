# Deimos Internship Tasks

#### This repository will be used to document my tasks as a Site Reliability Engineer intern in Deimos, these tasks include:


- #### Module 1: Linux: Installing nginx from source, adding a cron job to backup nginx folders, and creating nginx user and group.

- #### Module 2: Containerisation: Containerising a PHP application that will write data to a mysql database and also persist data.

- #### Module2: Container Orchestration: Creating a kubernetes cluster locally which will have a deployment manifest for the php application and a stateful set for the mysql instance and a service to make it accessible.

- #### Module3: Cloud Native CICD: Create a Tekton pipeline that will build all of the container images for the application, the pipeline needs to push the container images to your local container registry located in your devcontainer. Create an ArgoCD configuration that will use the above Helm chart to deploy the application to your local kubernetes cluster located in the devcontainer.

- #### Module4: Monitoring and Observability (Using the Dev Container and folder structure from Module 3): Define metrics critical to monitor MySQL and Kubernetes cluster, Deploy MySQL into the cluster via GitOps with a helm chart, Deploy and Configure the Grafana Agent via GitOps and send metrics and logs to local Prometheus & Loki, Monitor MySQL, the MiniKube instance and workloads using the Grafana Agent, Create Custom Dashboards to Display your Critical Metrics in Grafana, and Define and configure alerts to trigger on both events and thresholds.

 
