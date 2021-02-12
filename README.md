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

It supports 
```bash
oc start-build dockerfile-example --from-dir=./ -F
```

command. This will upload current directory to the build server and commence
a container image build according to the `Dockerfile` file.

## Quick start

Login, select the correct project, create the build and image objects, and start the build of the local Dockerfile.

```
# oc login ..
# oc project ...
oc create -f k8s-api-objs.yaml
oc start-build dockerfile-example --from-dir=./ -F
```

