{{/*
The External Secret object to be created.
*/}}
{{- define "common.external-secret" }}
{{- range $k := index .Values "external-secrets" }}
---
apiVersion: external-secrets.io/v1beta1
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
      type:  {{ $k.target.template.type | default "Opaque" }}
      engineVersion: {{ $k.target.template.engineVersion | default "v2" }}
      {{- with $k.target.template.metadata }}
      metadata:
        labels:
          {{- include "common.labels" $ | nindent 12 }}
          {{- with $k.target.template.metadata.labels }}
          {{- toYaml . | nindent 12 }}
          {{- end }}
        annotations:
          {{- include "common.annotations" $ | nindent 12 -}}
          {{- with $k.target.template.metadata.annotations }}
          {{- toYaml . | nindent 12 }}
          {{- end }}
      {{- end }}
      {{- with $k.target.template.data }}
      data: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $k.target.template.templateFrom  }}
      templateFrom: {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- end }}
  {{- with $k.data }}
  data:
  {{- range $k.data }}
  - secretKey: {{ .secretKey }}
    remoteRef:
      key: {{ .remoteRef.key }}
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
  {{- end }}
  {{- with $k.dataFrom }}
  data:
  {{- range $k.dataFrom }}
  - secretKey: {{ .secretKey }}
    remoteRef:
      key: {{ .remoteRef.key }}
      metadataPolicy: {{ .remoteRef.metadataPolicy }}
      property: {{ .remoteRef.property }}
      version: {{ .remoteRef.version }}
      conversionStrategy: {{ .remoteRef.conversionStrategy }}
      decodingStrategy: {{ .remoteRef.decodingStrategy }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
