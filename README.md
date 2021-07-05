# circleci-and-ArgoCD-CI-CD

```docker build --build-arg code_version=210705-4c3fcd3 --build-arg db-name=mysql  -t bikclu/sample-app:1.0.0 .```

```helm install my-sample-app ./myapp-helm-chart``` 

Configure as per ArgoCD document [ArgoCD](https://argo-cd.readthedocs.io/en/stable/).
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd_cfg1.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd_cfg.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd_cfg22.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd_sync.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/argocd.png) 
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/circleci_build.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/pod_status.png)
![image](https://github.com/becash143/circleci-and-ArgoCD-CI-CD/blob/main/sampleapp_log.png) 


---
**NOTE**

ArgoCD updates the application based on the github commits. Here, as soon as circleci pushes the image to private docker hub registry, ArgoCD updates the images, since the imageTag in values.yaml is updated in the bild process.

---

