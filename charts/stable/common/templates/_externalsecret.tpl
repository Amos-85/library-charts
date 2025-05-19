{{/*
Renders the remoteRef block.
Usage: include "common.remoteRef" (dict "remoteRef" .remoteRef)
*/}}
{{- define "common.remoteRef" -}}
key: {{ required "remoteRef.key is required" .remoteRef.key }}
{{- with .remoteRef.metadataPolicy }}
metadataPolicy: {{ . }}
{{- end }}
{{- with .remoteRef.property }}
property: {{ . }}
{{- end }}
{{- with .remoteRef.version }}
version: {{ . }}
{{- end }}
{{- with .remoteRef.conversionStrategy }}
conversionStrategy: {{ . }}
{{- end }}
{{- with .remoteRef.decodingStrategy }}
decodingStrategy: {{ . }}
{{- end }}
{{- end }}

---
{{/*
The External Secret object to be created.
*/}}
{{- define "common.external-secret" }}
{{- range $k := index .Values "external-secrets" }}
---
apiVersion: external-secrets.io/v1
kind: {{ $k.kind | default "ExternalSecret" }}
metadata:
  name: {{ $k.name }}
  labels: {{- include "common.labels" $ | nindent 4 }}
  annotations: {{- include "common.annotations" $ | nindent 4 }}
spec:
  refreshInterval: {{ $k.refreshInterval | default "10m" }}
  {{- with $k.namespaceSelector }}
  namespaceSelector:
    matchLabels:
      {{- toYaml . | nindent 10 }}
  {{- end }}
  secretStoreRef:
    name: {{ $k.secretStoreRef.name }}
    kind: {{ $k.secretStoreRef.kind }}
  target:
    name: {{ $k.target.name }}
    creationPolicy: {{ $k.target.creationPolicy | default "Owner" }}
    deletionPolicy: {{ $k.target.deletionPolicy | default "Retain" }}
    {{- with $k.target.template }}
    template:
      type:  {{ .type | default "Opaque" }}
      engineVersion: {{ .engineVersion | default "v2" }}
      {{- with .metadata }}
      metadata:
        labels:
          {{- include "common.labels" $ | nindent 12 }}
          {{- with .labels }}
          {{- toYaml . | nindent 12 }}
          {{- end }}
        annotations:
          {{- include "common.annotations" $ | nindent 12 }}
          {{- with .annotations }}
          {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- end }}
      {{- with .data }}
      data: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .templateFrom  }}
      templateFrom: {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
  {{- with $k.data }}
  data:
  {{- range $entry := $k.data }}
  - secretKey: {{ $entry.secretKey }}
    remoteRef:
      {{- include "common.remoteRef" (dict "remoteRef" $entry.remoteRef) | nindent 4 }}
  {{- end }}
  {{- end }}
  {{- with $k.dataFrom }}
  dataFrom:
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end }}
{{- end }}
