# k8s-test
An implementation using terraform and puppet of a kubernetes cluster using https://github.com/kelseyhightower/kubernetes-the-hard-way

STILL UNDER DEVELOMENT, there are a couple of things that need to be changed, for example balancer ip is hardcoded (among other things).

Also, the worker nodes are not working yet

## Installation
You just have to have docker installed (also make).

## Execution
The script will create everything needed. You'll need to pass your AWS key pair with admin priviledges.

```
AWS_SECRET_ACCESS_KEY=SECRET AWS_ACCESS_KEY_ID=NO_SECRET ./bin/cli example
```

This is just a way of testing stuff NO WARRANTY OF ANY KIND. The script is idempotent.
