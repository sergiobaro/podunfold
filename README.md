# podunfold

Clone an app with many pods in one command

## unfold.yml

```yml
pods: # list of pods
  - name: App # pod name
    type: app # app | example | pod (pod by default)
    git: https://git.com/app
  - name: Pod
    git: https://git.com/pod
  - name: ExampleApp
    type: example
    git: https://git.com/example

configs: # list of different configurations of pods
  - name: AppConfig # configuration name
    pods: # list of pods in the configuration
      App: develop # branch to clone
      Pod: feature/branch
  - name: ExampleConfig
    pods:
      Example: develop
      Pod: feature/branch
  - name: ShallowConfig
    shallow: false # shallow clone (--depth 1)
    pods:
      App: feature/branch
      Pod: feature/branch
```

### Types:
- app: the package is an app
- example: the package is a pod with an example app (Example folder)
- pod: it's a pod without an Example app.

The type is used detect the host app. The host app Podfile is modified to point to the path of the other pods in the configuration.

Any configuration has to have an app or an example.
