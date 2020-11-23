# podunfold

Clone an app with many development pods in one command

## Command `unfold`

Clones all the pods specificied in the selected configuration. 

```bash
$ podunfold <config_file> <config_name>
```
- The config file name by default is unfold.yml
- If a config name is not specified it will present a list of the configurations found in the default config file, if it exists. 
The configuration to unfold can be selected by number.


### Configuration file (unfold.yml)

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

configs: # list of configurations
  - name: AppConfig # configuration name
    pods: # list of pods in the configuration
      App: develop # pod name and branch to clone
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

### Pod types:
- app: the package is an app
- example: the package is a pod with an example app (Example folder)
- pod: it's a pod without an Example app.

The type is used to detect the host app. The host app Podfile is modified to point to the path of the other pods in the configuration.

Any configuration has to have an app or an example to act as a host.


### Command `clone`

```bash
$ podunfold clone <pod_name>
```
