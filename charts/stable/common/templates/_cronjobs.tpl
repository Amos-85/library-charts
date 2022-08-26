{{- define "common.cronjob" -}}
{{- range $cronjob := .Values.cronjob }}
---
{{ $name := include "common.names.fullname" $ }}
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $cronjob.name }}
  {{- with (merge ($cronjob.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($cronjob.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations:
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with $cronjob.concurrencyPolicy }}
  concurrencyPolicy: {{ . }}
  {{- end }}
  {{- with $cronjob.failedJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ . }}
  {{- end }}
  {{- with $cronjob.successfulJobsHistoryLimit }}
  successfulJobsHistoryLimit: {{ . }}
  {{- end }}
  {{- with $cronjob.schedule | quote }}
  schedule: {{ . }}
  {{- end }}
  {{- with $cronjob.startingDeadlineSeconds }}
  startingDeadlineSeconds: {{ . }}
  {{- end }}
  {{- with $cronjob.suspend }}
  suspend: {{ . }}
  {{- end }}
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            {{- include "common.labels.selectorLabels" $ | nindent 12 }}
            {{- with $cronjob.podLabels }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
        {{- with $cronjob.podAnnotations }}
          annotations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
        spec:
          {{- with $cronjob.serviceAccountName }}
          serviceAccountName: {{ . }}
          {{- end }}
          {{- if $cronjob.securityContext }}
          securityContext:
            {{- if index $cronjob "securityContext" "runAsUser" }}
            runAsUser: {{ index $cronjob "securityContext" "runAsUser" }}
            {{- end }}
            {{- if index $cronjob "securityContext" "runAsGroup" }}
            runAsGroup: {{ index $cronjob "securityContext" "runAsGroup" }}
            {{- end }}
            {{- if index $cronjob "securityContext" "fsGroup" }}
            fsGroup: {{ index $cronjob "securityContext" "fsGroup" }}
            {{- end }}
          {{- end }}
          {{- with $cronjob.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 10 }}
          {{- end }}
          restartPolicy: {{ $cronjob.restartPolicy }}
          containers:
          - name: {{ $cronjob.name }}
            image: {{ index $cronjob "image" "repository" }}:{{ index $cronjob "image" "tag" }}
            imagePullPolicy: {{ $cronjob.image.imagePullPolicy | default "Always" }}
            {{- with $cronjob.env }}
            env:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjob.envFrom }}
            envFrom:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjob.command }}
            command: {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjob.args }}
            args:
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $cronjob.resources }}
            resources:
              {{- toYaml . | nindent 14 }}
            {{- end }}
            {{- with $cronjob.volumeMounts }}
            volumeMounts:
              {{- toYaml . | nindent 12 }}
            {{- end }}
          {{- with $cronjob.nodeSelector }}
          nodeSelector:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjob.affinity }}
          affinity:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjob.tolerations }}
          tolerations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with $cronjob.volumes }}
          volumes:
            {{- toYaml . | nindent 10 }}
          {{- end }}
  {{- end }}
{{- end }}