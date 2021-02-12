# Building a container image on CLI

First, lets create the given api-objects.

* ImageStream object could be created from web console as well easily

```yaml
# ImageStream

apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  annotations:
    openshift.io/generated-by: OpenShiftNewApp
  creationTimestamp: null
  labels:
    app: dockerfile-example
  name: dockerfile-example
```

The following BuildConfig object is suitable for manual CLI builds. 
```yaml
# BuildConfig

apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  labels:
    app: dockerfile-example
  name: dockerfile-example
spec:
  source: 
    binary: {}
  output:
    to:
      kind: ImageStreamTag
      name: dockerfile-example:latest
  strategy:
    dockerStrategy: {}
```

The following DeploymentConfig can be used to ensure changes made to our 
service is done without interruptions in a rolling update manner. It also 
lets us maintain a defined set of replica pods supporting our service, lets 
us specify what triggers an update, and more. 

```yaml
# DeploymentConfig

apiVersion: v1
kind: DeploymentConfig
metadata:
  name: dockerfile-example
  labels:
    app: dockerfile-example
spec:
  template: 
    metadata:
      labels:
        name: dockerfile-example
    spec:
      containers:
        - name: dockerfile-example
          image: dockerfile-example
          ports:
            - containerPort: 8080
  replicas: 1 
  triggers:
    - type: ConfigChange 
    - type: ImageChange
      imageChangeParams:
        automatic: true
        containerNames:
          - dockerfile-example
        from:
          kind: ImageStreamTag
          name: dockerfile-example:latest
  strategy: 
    type: Rolling
  paused: false 
  revisionHistoryLimit: 5 
  minReadySeconds: 0
```

Also check out the other Kubernetes/OpenShift objects included in `k8s-api-objs.yaml`, the Service and the Router, which 
are responsible for providing a predictable way of accessing our application from inside and outside (publicly) of our project.  


It supports 
```bash
oc start-build dockerfile-example --from-dir=./ -F
```

command. This will upload current directory to the build server and commence
a container image build according to the `Dockerfile` file.

