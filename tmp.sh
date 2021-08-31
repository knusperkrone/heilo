---


apiVersion: v1
kind: Service

metadata:
  name: {{ .Chart.Name }}-service
spec:
  type: NodePort
  selector:
    tier: {{ .Chart.Name }}

  ports:
    - protocol: TCP
      port: 5672
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      tier: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        tier: {{ .Chart.Name }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}

          env:
            - name: RABBITMQ_DEFAULT_USER
              value: "{{ .Values.global.rabbitmq.username }}"
            - name: RABBITMQ_DEFAULT_PASS
              value: "{{ .Values.global.rabbitmq.password }}"
            - name: RABBITMQ_ERLANG_COOKIE
              value: "{{ .Values.global.rabbitmq.coockie }}"

          ports:
            - containerPort: 5672

          livenessProbe:
            failureThreshold: 3
            tcpSocket:
              port: 5672
            initialDelaySeconds: 60
            periodSeconds: 60
            successThreshold: 1
            timeoutSeconds: 10

          readinessProbe:
            failureThreshold: 3
            tcpSocket:
              port: 5672
            initialDelaySeconds: 60
            periodSeconds: 60
            successThreshold: 1
            timeoutSeconds: 10

