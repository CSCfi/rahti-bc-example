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
    app: dfile-test
  name: dfile-test
```

The following BuildConfig object is suitable for manual CLI builds. 
```yaml
# BuildConfig

apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  labels:
    app: dfile-test
  name: dfile-test
spec:
  source: 
    binary: {}
  output:
    to:
      kind: ImageStreamTag
      name: dfile-test:latest
  strategy:
    dockerStrategy:
      from:
        kind: DockerImage
        name: nginx:mainline-alpine
    type: Docker
```

It supports 
```bash
oc start-build dfile-test --from-dir=./ -F
```

command. This will upload current directory to the build server and commence
a container image build according to the `Dockerfile` file.

