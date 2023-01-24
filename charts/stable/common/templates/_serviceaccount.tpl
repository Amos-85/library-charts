{{/*
The ServiceAccount object to be created.
*/}}
{{- define "common.serviceAccount" }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "common.names.serviceAccountName" . }}
  {{- with (merge (.Values.serviceAccount.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge (.Values.serviceAccount.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
