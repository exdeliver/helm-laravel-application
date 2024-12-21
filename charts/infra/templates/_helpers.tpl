{{/*
Generate a full name for the chart
*/}}
{{- define "infra.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "infra.labels" -}}
app: {{ include "infra.fullname" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Generate a name for the service
*/}}
{{- define "infra.serviceName" -}}
{{- printf "%s-service" (include "infra.fullname" .) -}}
{{- end -}}

{{/*
Generate a name for the deployment
*/}}
{{- define "infra.deploymentName" -}}
{{- printf "%s-deployment" (include "infra.fullname" .) -}}
{{- end -}}