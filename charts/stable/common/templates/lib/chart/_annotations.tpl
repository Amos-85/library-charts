{{/* Common annotations shared across objects */}}
{{- define "common.annotations" -}}
  {{- with .Values.global.annotations }}
    {{- range $k, $v := . }}
      {{- $name := $k }}
      {{- $value := tpl $v $ }}
{{ $name }}: {{ quote $value }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/* Determine the Pod annotations used in the controller */}}
{{- define "common.podAnnotations" -}}
  {{- if .Values.podAnnotations -}}
    {{- tpl (toYaml .Values.podAnnotations) . | nindent 0 -}}
  {{- end -}}

  {{- $configMapsFound := false -}}
  {{- $secretFound := false -}}
  {{- range $name, $configmap := .Values.configmap -}}
    {{- if $configmap.enabled -}}
      {{- $configMapsFound = true -}}
    {{- end -}}
  {{- end -}}
  {{- range $name, $secret := .Values.secret -}}
    {{- if $secret -}}
      {{- $secretFound = true -}}
    {{- end -}}
  {{- end -}}
  {{- if $configMapsFound -}}
    {{- printf "checksum/config: %v" (include ("common.configmap") . | sha256sum) | nindent 0 -}}
  {{- end -}}
  {{- if $secretFound -}}
    {{- printf "checksum/secret: %v" (include ("common.secret") . | sha256sum) | nindent 0 -}}
  {{- end -}}
{{- end -}}
