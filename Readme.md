Learning Kubernetes with Projects
=====================================

### MONGO-APP
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

### HELM-MONGO-APP
Its a simple helm application which is helpful in deploying same above application but in less code because of helm charts. We used helm charts to deploy mongoDB Application As StateFul Set with 3 Replication and for data persistent used Cloud-Storage.
Mongo-Express is a UI Application which will be deployed as Deployment Component with service to allow traffic and connect to mongoDB StateFul Set as an Internal Service.
For Public, We Will Use Ingress Service which will forward the traffic to Mongo-Express Service Port and it will route the data to MongoDB using Internal Service.
#### Application Workflow
![Helm-Mongo-App Workflow](https://github.com/nirdeshkumar02/Kubernetes-Learning/blob/master/helm-mongo-application.png)
#### Steps
1. Create EKS Cluster with Two Nodes on AWS and Configure it.
2. Check If Helm is installed on Cluster? If not Intall helm.
3. Add Bitnami Repo to Kubernetes which will helpful to deploy mongoDB.
    ```helm repo add bitnami https://charts.bitnami.com/bitnami```
4. Now, Install MongoDB Using Helm Charts with overriding the values from file `mongodb-values.yaml`.
    ```helm install mongodb --values mongodb-values.yaml bitnami/mongodb```
5. Here, MongoDB is deployed to kubernetes with persistent volume, services, secrets which we also deployed mongodb application above by creating these configuration file.
6. Create a Deployment File `mongo-express.yaml` and Service File `mongo-express-service.yaml` for mongo-express UI Application.
7. Deploy these configuration file.
    ```
    kubectl apply -f mongo-express.yaml
    kubectl apply -f mongo-express-service.yaml
    ```
8. Here, Mongo-Express UI application is deployed and connected with the MongoDB Database.
9. Now For Public, We deployed the `Nginx Ingress Controller` using Helm Charts.
    Take Refrence From Here - ```https://github.com/nginxinc/kubernetes-ingress/tree/main/deployments/helm-chart```.
10. Create Nginx-Ingress Service `nginx-ingress-service.yaml` for Route the Traffic for path.
11. Deploye the Nginx-Ingress Service File.
    ```kubectl apply -f nginx-ingress-service.yaml```

Your Application is now available to access from outside world using the hostname provide in the nginx-ingress-service file. 
