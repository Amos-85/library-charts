{{- define "common.extraDeploy" }}
---
{{- range .Values.extraDeploy }}
{{ . | toYaml }}
---
{{- end }}
{{- end }}
