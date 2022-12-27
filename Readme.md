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