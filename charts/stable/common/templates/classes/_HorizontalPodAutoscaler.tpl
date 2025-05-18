{{- define "common.classes.hpa" -}}
{{- if .Values.autoscaling.enabled -}}
{{- $hpaName := include "common.names.fullname" . -}}
{{- $targetName := include "common.names.fullname" . }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaName }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ include "common.names.controllerType" . }}
    name: {{ .Values.autoscaling.target | default $targetName }}
  minReplicas: {{ .Values.autoscaling.minReplicas | default 1 }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas | default 3 }}
  metrics:
    {{- if .Values.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}
    {{- if .Values.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
    {{- range .Values.autoscaling.externalMetrics }}
    - type: External
      external:
        metric:
          name: {{ required "external metric name is required" .name }}
          {{- if .selector }}
          selector:
            matchLabels:
              {{- toYaml .selector | nindent 14 }}
          {{- end }}
        target:
          type: {{ .target.type }}
          {{- if eq .target.type "Value" }}
          value: {{ .target.value }}
          {{- else if eq .target.type "AverageValue" }}
          averageValue: {{ .target.averageValue }}
          {{- end }}
    {{- end }}
  {{- with .Values.autoscaling.behavior }}
  behavior:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}
