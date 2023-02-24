{{- define "common.job" -}}
{{- range $key, $job := .Values.job }}
---
{{ $name := include "common.names.fullname" $ }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $key }}
  {{- with (merge ($job.labels | default dict) (include "common.labels" $ | fromYaml) ) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($job.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations:
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with $job.backoffLimit }}
  backoffLimit: {{ . }}
  {{- end }}
  {{- with $job.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ . }}
  {{- end }}
  {{- with $job.ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ . }}
  {{- end }}
  {{- with $job.parallelism }}
  parallelism: {{ $job.parallelism }}
  {{- end }}
  {{- with $job.completions }}
  completions: {{ . }}
  {{- end }}
  {{- with $job.manualSelector }}
  manualSelector: {{ . }}
  {{- end }}
  template:
    metadata:
      labels:
      {{- include "common.labels.selectorLabels" $ | nindent 8 }}
      {{- with $job.podLabels }}
      {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $job.podAnnotations }}
      annotations:
      {{- toYaml . | nindent 8 }}
      {{- end }}
    spec:
      {{- with $job.serviceAccount }}
      serviceAccountName: {{ . }}
      {{- end }}
      {{- if $job.securityContext }}
      securityContext:
        {{- if index $job "securityContext" "runAsUser" }}
        runAsUser: {{ index $job "securityContext" "runAsUser" }}
        {{- end }}
        {{- if index $job "securityContext" "runAsGroup" }}
        runAsGroup: {{ index $job "securityContext" "runAsGroup" }}
        {{- end }}
        {{- if index $job "securityContext" "fsGroup" }}
        fsGroup: {{ index $job "securityContext" "fsGroup" }}
        {{- end }}
      {{- end }}
      {{- with $job.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 10 }}
      {{- end }}
      restartPolicy: {{ $job.restartPolicy }}
      containers:
      - name: {{ $job.name }}
        image: {{ index $job "image" "repository" }}:{{ index $job "image" "tag" }}
        imagePullPolicy: {{ $job.image.imagePullPolicy | default "Always" }}
        {{- with $job.env }}
        env:
          {{- toYaml . | nindent 12 }}
        {{- end }}
        {{- with $job.envFrom }}
        envFrom:
        {{- toYaml . | nindent 12 }}
        {{- end }}
        {{- with $job.command }}
        command: {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with $job.args }}
        args:
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with $job.resources }}
        resources:
        {{- toYaml . | nindent 8 }}
        {{- end }}
        {{- with $job.volumeMounts }}
        volumeMounts:
        {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- with $job.nodeSelector }}
      nodeSelector:
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- with $job.affinity }}
      affinity:
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- with $job.tolerations }}
      tolerations:
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- with $job.volumes }}
      volumes:
      {{- toYaml . | nindent 6 }}
      {{- end }}
  {{- end }}
{{- end }}