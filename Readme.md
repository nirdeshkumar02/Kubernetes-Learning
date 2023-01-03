Learning Kubernetes with Projects
=====================================

MONGO-APP
===========
It is a simple k8s application where we are connecting mongodb to mongo ui with internal service and allowed users to browse the mongo-ui with loadbalancer service.
#### Application Workflow
![Mongo-App Workflow](https://github.com/nirdeshkumar02/Kubernetes-Learning/blob/master/k8-mongo-app.png)
#### Steps
1. Create MongoDB Secret `mongo-db-secret.yaml` and Service file `mongo-db-service.yaml` before MongoDB configuration file.
2. Deploy Above Secret and Service File `kubectl apply -f <file name>`.
3. Create MongoDB Deployment Configuration file `mongo-db.yaml` with refrencing above files.
4. Now, Deploy this mongoDB deployment file `kubectl apply -f <file name>`.
4. Create Mongo-Express UI ConfigMap `mongo-express-configmap.yaml` and Service File `mongo-express-service.yaml`.
5. Deploy Above ConfigMap and Service File `kubectl apply -f <file name>`.
6. Now, Refrence Above files to the Mongo-Express Deployment Configuration File `mongo-express.yaml`.
7. Deploy this Mongo-Express Deployment Configuration file `kubectl apply -f <file name>`.

Now, You can access the mongo-express UI connected with the mongoDB Application.

HELM-MONGO-APP
===============
Its a simple helm application which is helpful in deploying same above application but in less code because of helm charts. We used helm charts to deploy mongoDB Application As StateFul Set with 3 Replication and for data persistent used Cloud-Storage.
Mongo-Express is a UI Application which will be deployed as Deployment Component with service to allow traffic and connect to mongoDB StateFul Set as an Internal Service.
For Public, We Will Use Ingress Service which will forward the traffic to Mongo-Express Service Port and it will route the data to MongoDB using Internal Service.
#### Application Workflow
![Helm-Mongo-App Workflow](https://github.com/nirdeshkumar02/Kubernetes-Learning/blob/master/helm-mongo-application.png)
#### Steps
1. Create EKS Cluster with Two Nodes on AWS and Configure it.
2. Check If Helm is installed on Cluster? If not Intall helm.
3. Add Bitnami Repo to Kubernetes which will helpful to deploy mongoDB.
    ```
    helm repo add bitnami https://charts.bitnami.com/bitnami
    ```
4. Now, Install MongoDB Using Helm Charts with overriding the values from file `mongodb-values.yaml`.
    ```
    helm install mongodb --values mongodb-values.yaml bitnami/mongodb
    ```
5. Here, MongoDB is deployed to kubernetes with persistent volume, services, secrets which we also deployed mongodb application above by creating these configuration file.
6. Create a Deployment File `mongo-express.yaml` and Service File `mongo-express-service.yaml` for mongo-express UI Application.
7. Deploy these configuration file.
    ```
    kubectl apply -f mongo-express.yaml
    kubectl apply -f mongo-express-service.yaml
    ```
8. Here, Mongo-Express UI application is deployed and connected with the MongoDB Database.
9. Now For Public, We deployed the `Nginx Ingress Controller` using Helm Charts. Take Refrence From Here - 
    ```
    https://github.com/nginxinc/kubernetes-ingress/tree/main/deployments/helm-chart
    ```
10. Create Nginx-Ingress Service `nginx-ingress-service.yaml` for Route the Traffic for path.
11. Deploye the Nginx-Ingress Service File.
    ```
    kubectl apply -f nginx-ingress-service.yaml
    ```

Your Application is now available to access from outside world using the hostname provide in the nginx-ingress-service file. 

PRIVATE-IMAGE-DEPLOYMENT
=============================================
Let We Build a CICD Pipeline which Checkout the code from GitHub, Do Some Test, Build/Package the Application and Pushed image to Private Repository like Docker Private Registry, AWS ECR etc... Now, This Project is all about how can you deploy this private image to Kubernetes.

#### There are two steps through which you can authenticate yourself and Deploy the image on K8s -
1. Create Secret Component which contains credential for Docker Registry.
2. Configure Deployment/Pod to use Secret using `imagePullSecrets`.

#### Prerquisites - You should have a Private Registry having Image whether it is AWS ECR or Docker Private Registry.

#### Steps

- If You are Using Minikube then first you need to run `minikube ssh` command to enter inside your minikube cluster becasue minikube is also using `driver=docker` so that we need to perform these operation inside minikube.
- If You are Using K8s Cluster Then You are good to go with these command.

#### FROM STEP 1 - 4 IS VERY USEFUL WHEN YOU HAVE MORE THAN 1 DIFFERENT DOCKER REGISTRY FROM DIFFERENT ACCOUNT, SO THAT YOU CAN LOGIN TO EACH ACCOUNT AND THOSE CREDENTIAL WILL STORE IN ".docker/config.json" FILE AND YOU CAN USE THIS FILE WITHOUT ANY HEADACHE AT ONE TIME.

#### FROM STEP 5 IS USEFUL WHEN YOU HAVE ONLY 1 DOCKER ACCOUNT FROM WHERE YOU WANT TO PULL THE IMAGE FROM PRIVATE REPO, SO IF THIS CONDITION SATISFY YOUR NECESSITY THEN YOU CAN DIRECTLY JUMP TO THE STEP 5. 

1. Login to your private registry -
    #### If You are using AWS ECR as Your Private Registry
    ```
    # Print Full Docker Login Command For AWS ECR
    aws ecr get-login
    # Now, Copy that full command from the terminal and Run it.
    ```
    #### If You are using Docker Private Registry
    ```
    docker login -u <username> -p <password>
    ```
2. Login will generate a config.json file under .docker directory using which we will create our `Secret File`.
    ```
    cat .docker/config.json
    ```
3. If Using Minikube - Copy that .docker/config.json file from minikube cluster to your host (laptop)
    ```
    # Command - scp -i <ssh-key> <user@ip-address:file-name> <destination> - Replacing Existing Docker Config Json File on Host with the file.
    scp -i $(minikube ssh-key) docker@$(minikube ip):.docker/config.json C:\Users\nksai\.docker/config.json
    ```
4. Create `Secret File` with the docker config.json file.
    #### Using Imperetive (Command)
    ```
    kubectl create secret generic private-registry-key --from-file=.dockerconfigjson=.docker/config.json --type=kubernetes.io/dockerconfigjson
    kubect get secret
    ```
    #### Using Declarative (Creating Secret File)
    ```
    # Run the command and copy the encoded text from terminal
    cat .docker/config.json | base64
    # Add the copied text to your secret configuration file under the attribute `.dockerconfigjson`.
    # Now, Deploy the Secret Configuration file 
    kubectl apply -f <fileName>
    ```
5. Create `Secret File` with the credentials.
    #### For Docker Private Registry
    ```
    kubectl create secret docker-registry private-registry-key --docker-server=https://private-repo --docker-username=<username> --docker-password=<password>
    ```
    #### For AWS ECR Private Registry
    ```
    # Get Details of Docker creds by running the command
    aws ecr get-login
    # Put the required field value to the below command
    kubectl create secret docker-registry private-registry-key --docker-server=https://<accountId>.dkr.ecr.<region-name>.amazonaws.com --docker-username=AWS --docker-password=<password>
    ```
6. Create `Deployment File` to use the image, secret and deploy the file.
    ```
    kubectl apply -f <deployment-fileName>
    ```

SETUP-PROMETHEUS-MONITORING
=============================
This Project is handson How can we deploy monitoring tool Prometheus with K8s Operator and Helm. In this Project, we will look on -
- Insalled Prometheus Operator Helm Chart
- Access Grafana UI (Configure Port Forward)
- Access Prometheus UI (Configure Port Forward)

#### Ways to deploy the prometheus in k8s
1. Creating all configuration file yourself and execute them in the right order like prometheus, grafana, alertmanager, configMap, Secrets, Services.
2. Using an operator. It will manage all prometheus component for stateful application.
3. Using the helm chart to deploy operator.

- We will deploy the promethus with Helm Chart.

#### Steps
1. install the operator using helm chart. It will deploy all the parts required to prometheus.
    - Here 2 Stateful Set - Prometheus and AlertManager.
    - Also 2 Deployment - Kube-State-Metrics, Grafana.
    - Also 1 DeamonSet - Prometheus Node Exportor.
    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    helm repo update
    helm install prometheus prometheus-community/kube-prometheus-stack --version "9.4.1"
    ```
2. Now, You can access the deployment, statefull set etc and check the configuration.
3. For Access the Grafana UI you can use port-forwarding.
    ```
    kubectl port-forward deployment/prometheus-grafana 3000
    username - admin
    password - prom-operator
    ```
4. For Access the Prometheus UI using port-forwarding.
    ```
    kubectl port-forward prometheus-prometheus-prometheus-oper-prometheus-0 9090
    ```

DEPLOYING-MICROSERVICES-APPLICATION
====================================
For Deploying a microservices based application, we need to figure out some queries to setup an architecture.
1. How microservices are connected to each other?
2. Image Name for each microservices.
3. What environment variables and ports of each microservices expects?

So, After knowing all queries, Create Deployment Config and Service Config for each microservices and connect them to each other.
#### Microservice Application Workflow
![Microservice-Application Workflow](https://github.com/nirdeshkumar02/Kubernetes-Learning/blob/master/microservices.png)
The Application Code we used for this microservice application is "OPEN SOURCE GOOGLE SAMPLE CODE"
For External Users, we create an external service which will connect to our frontend internal service "ClusterIP" and forward the request.

The project folder contains bad practice of configuration file which can't be use for production and security purposes. So Now To remove the bad practices make these changes -
1. Provide Tag to images under container, otherwise every time it will fatch the latest tag.
2. Liveness Probe for each container to check the application inside the pod is running or not.
    ```yml
    livenessProbe:
        periodSeconds: 5
        exec:
            command: ["/bin/grpc_health_probe", "-addr=:port"]
    ```
    for redis cluster
    ```yml
    livenessProbe:
        initialDelaySeconds: 5
        periodSeconds: 5
        tcpSocket:
            port: 6379
    ```
3. Rediness Probe for each container to check whether the application inside the pod is ready to serve or not.
    ```yml
    readinessProbe:
        periodSeconds: 5
        exec:
            command: ["/bin/grpc_health_probe", "-addr=:port"]
    ```
    for redis cluster
    ```yml
    readinessProbe:
        initialDelaySeconds: 5
        periodSeconds: 5
        tcpSocket:
            port: 6379
    ```
4. Provide Resource Request and Limits for each container according to their requiremets.
    ```yml
    resources:
        requests:
            cpu: 100m
            memory: 64Mi
        limits:
            cpu: 200m
            memory: 128Mi
    ```
5. Don't Expose your nodePort. Use type LoadBalancer.
6. Always Deploy more than 1 replicas.
7. Always Use more than 1 worker node.

HELM CHART CREATION FOR MICROSERVICES
=======================================
In Previous Project, We have 10 configuration files for Deployment and Services with respect to different microservices. It is tediuous task to create multiple configuration files as they have same data with some changes like, metadata-name, selector, ports etc.
So, By creating helm chart for the microservices application, it will make our work handy because we are reusing the single configuration.
#### STEPS
1. Create the helm chart structure in microservices-helm-charts folder.
    ```
    helm create microservices 
    helm create redis
    ```
2. Now, Inside the helm folder, under the templates we will create the template for deployment and service configuration.
3. Now, in values.yaml file set values of variable name used in deployment and service config file and use them for deploying diff microservices.
4. Now, Validate the entered value through helm whether its correct or not
    ```
    "helm template helps in render chart templates locally and display the output"
    helm template -f <service-file> <chart-name>
    example - helm template -f values/email-service-values.yaml charts/microservices
    ```
5. Install the helm chart by creating a script file `install.sh` and add all install commands for each config file.
    ```sh
    helm install -f values/<fileName> <serviceName> charts/<microservice/redis>
    example - helm install -f values/email-service-values.yaml emailService charts/microservices
    ```
6. To Unistall the charts, again create `uninstall.sh` and provide the commands for each config.
    ```sh
    helm uninstall releaseName
    example - helm uninsall emailService
    ```

#### HELM COMMANDS
- Set HELM Values ```helm template -f values/email-service-values.yaml --set appReplicas=3 charts/microservices```
- Validate HELM File Syntax ```helm lint -f values/email-service-values.yaml charts/microservices```
- Install HELM CHART ```helm install -f values/email-service-values.yaml emailservice charts/microservices```
- Check Generated Manifest without Installing Chart ```helm install --dry-run -f values/redis-values.yaml rediscart charts/redis```

#### DEPLOYING MICROSERVICE CHARTS WITH HELMFILE
Helm install for each microservice deployement is the tedious task and unhandy So, we are deploying the microservices through helmfile.
Through HelmFile we can deploy the application in the automated way, We just need to refrence the charts to values and service name.

- Helmfile - It is a declarative way for deploying helm charts. 
We just need to declare a definition of an entire k8s cluster.

- install the helmfile tool and then using tool we are deploying helmfile
- Install the helmfile ```helmfile sync```
- Unistall the helmfile ```helmfile destroy```
- Using `helmfile` we can add it to CICD and build the application.

#### We can host the helm chart to the git repository - with 2 options
1. With your application code.
2. Seperate Git Repo for helm charts.
