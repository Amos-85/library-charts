{{/*
The Secret object to be created.
*/}}
{{- define "common.secret" }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.names.fullname" . }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
type: {{ .Values.secret.type | default "Opaque" }}
{{- with .Values.secret.data }}
stringData:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
