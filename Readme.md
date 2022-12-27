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
