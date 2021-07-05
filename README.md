# circleci-and-ArgoCD-CI-CD

```docker build --build-arg code_version=210705-4c3fcd3 --build-arg db-name=mysql  -t bikclu/sample-app:1.0.0 .```

```helm install my-sample-app ./myapp-helm-chart``` 

Configure as per ArgoCD document [ArgoCD](https://argo-cd.readthedocs.io/en/stable/).
![Alt text](argocd_cfg.png ?raw=true "Optional ArgoCD config")
![Alt text](argocd.png ?raw=true "Optional ArgoCD config")
![Alt text](circleci_build.png ?raw=true "Optional circleci build")
![Alt text](circleci.png ?raw=true "Optional circleci")
![Alt text](pod_status.png  ?raw=true "Optional Running Pods")
![Alt text](sampleapp_log.png  ?raw=true "Optional sample-app log")

---
**NOTE**

ArgoCD updates the application based on the github commits. Here, as soon as circleci pushes the image to private docker hub registry, ArgoCD updates the images, since the imageTag in values.yaml is updated in the bild process.

---
