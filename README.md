# Dockerized ElastAlert

![https://img.shields.io/docker/v/bigdataboutique/elastalert]  ![https://img.shields.io/docker/pulls/bigdataboutique/elastalert]

[ElastAlert](https://github.com/Yelp/elastalert) by Yelp is a Python-based utility for enabling alerting for the Elastic Stack. This is an easy-to-use dockerized version of it, with focus on Kubernetes compatibility and flexibility.

## Usage (Kubernetes)

Rules should be mounted to the container, and the preferred way of doing this is via a ConfigMap.

To create a ConfigMap containing the rules for the ElastAlert deployment, use the following on a folder `rules/` containing the rules yaml files:

```bash
kubectl create configmap elastalert-rules --from-file=rules/ -o yaml
```

A typical Deployment of ElastAlert would then look like this:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: elastalert
  labels:
    app: elastalert
spec:
  replicas: 1
  selector:
    matchLabels:
      app: elastalert
  template:
    metadata:
      labels:
        app: elastalert
    spec:
      containers:
        - name: elastalert
          image: bigdataboutique/elastalert
          imagePullPolicy: IfNotPresent
          env:
            - name: ES_HOST
              value: "es-helm-master"
            - name: ES_PORT
              value: "9200"
            - name: ENV_NAME
              value: "test"
            - name: ELASTALERT_CONFIGS
              value: |
                # any configs that you need added to config.yaml
          volumeMounts:
            - name: rules
              mountPath: /app/rules
              readOnly: false
      volumes:
        - name: rules
          configMap:
            name: elastalert-rules
      restartPolicy: Always
```

When updating the rules you'd need to restart the ElastAlert pod:

```bash
kubectl delete configmap elastalert-rules
kubectl create configmap elastalert-rules --from-file=rules/ -o yaml
kubectl scale deployment/elastalert --replicas=0
kubectl scale deployment/elastalert --replicas=1
```

## Environment Variables

This container setup will do environment variable substitution in all rule files and config.yaml. Some environment variables are already defined and have to be set:

* ES_HOST and ES_PORT of the Elasticsearch being queried for events
* ENV_NAME is the environment name to run ElastAlert on, will be used for naming the ElastAlert backend indexes
* ELASTALERT_CONFIGS (optional), use this to append any configs you need for config.yaml
