{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "annotationlab.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "annotationlab.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "annotationlab.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "annotationlab.labels" -}}
helm.sh/chart: {{ include "annotationlab.chart" . }}
{{ include "annotationlab.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "annotationlab.selectorLabels" -}}
app.kubernetes.io/name: {{ include "annotationlab.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "annotationlab.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "annotationlab.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.registryCredentials.registryUrl (printf "%s:%s" .Values.registryCredentials.username .Values.registryCredentials.password | b64enc) | b64enc }}
{{- end }}

{{/*
Create a default fully qualified app name for the annotationlab requirement.
*/}}
{{- define "annotationlab.annotationlab.fullname" -}}
{{- $annotationlabContext := dict "Values" .Values "Release" .Release "Chart" (dict "Name" "annotationlab") -}}
{{ include "annotationlab.fullname" $annotationlabContext }}
{{- end }}

{{/*
Create a default fully qualified app name for the keycloak requirement.
*/}}
{{- define "annotationlab.keycloak.fullname" -}}
{{- $keycloakContext := dict "Values" .Values "Release" .Release "Chart" (dict "Name" "keycloak") -}}
{{ include "keycloak.fullname" $keycloakContext }}
{{- end }}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "annotationlab.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ include "postgresql.fullname" $postgresContext }}
{{- end }}

{{/*
Create a default fully qualified app name for the airflow requirement.
*/}}
{{- define "annotationlab.airflow.fullname" -}}
{{- $airflowContext := dict "Values" .Values.airflow "Release" .Release "Chart" (dict "Name" "airflow") -}}
{{ include "airflow.fullname" $airflowContext }}
{{- end }}

{{/*
Create a default fully qualified app name for the airflow postgres requirement.
*/}}
{{- define "annotationlab.airflow.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.airflow.postgresql "Release" .Release "Chart" (dict "Name" "airflow.postgresql") -}}
{{ include "postgresql.fullname" $postgresContext }}
{{- end }}

{{/*
Create a default fully qualified app name for the keycloak postgres requirement.
*/}}
{{- define "annotationlab.keycloak.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.keycloak.postgresql "Release" .Release "Chart" (dict "Name" "keycloak.postgresql") -}}
{{ include "postgresql.fullname" $postgresContext }}
{{- end }}

{{/*
Get annotationlab url
*/}}
{{- define "annotationlab.url" -}}
  {{- if .Values.configuration.url -}}
    {{ .Values.configuration.url }}
  {{- else if .Values.ingress.enabled -}}
    {{- if .Values.ingress.tls -}}
https://{{ index (( index .Values.ingress.tls 0 ).hosts) 0 }}{{ (index .Values.ingress.hosts 0 ).path }}
    {{- else -}}
http://{{ (index .Values.ingress.hosts 0 ).host }}{{ (index .Values.ingress.hosts 0 ).path }}
    {{- end -}}
  {{- else -}}
http://{{ include "annotationlab.fullname" . }}{{ (index .Values.ingress.hosts 0 ).path }}
  {{- end -}}
{{- end -}}

{{/*
Get annotationlab base url
*/}}
{{- define "annotationlab.base_url" -}}
  {{- if .Values.configuration.base_url -}}
    {{ .Values.configuration.base_url }}
  {{- else if .Values.ingress.enabled -}}
{{ (index .Values.ingress.hosts 0 ).path }}
  {{- else -}}
/
  {{- end -}}
{{- end -}}

{{/*
Get or use defined keycloak url
*/}}
{{- define "annotationlab.keycloak.url" -}}
  {{- if .Values.configuration.KEYCLOAK_SERVER_URL -}}
    {{ .Values.configuration.KEYCLOAK_SERVER_URL }}
  {{- else if .Values.installKeycloak -}}
    {{- if .Values.keycloak.ingress.enabled -}}
      {{- if .Values.keycloak.ingress.tls -}}
https://{{ index (( index .Values.keycloak.ingress.tls 0 ).hosts) 0 }}/auth/
      {{- else if .Values.keycloak.ingress.rules -}}
http://{{ index (index .Values.keycloak.ingress.rules 0).host }}/auth/
      {{- end -}}
    {{- else if .Values.ingress.enabled -}}
      {{- if .Values.ingress.tls -}}
https://{{ index (( index .Values.ingress.tls 0 ).hosts) 0 }}/auth/
      {{- else -}}
http://{{ (index .Values.ingress.hosts 0 ).host }}/auth/
      {{- end -}}
    {{- else -}}
http://{{ include "annotationlab.keycloak.fullname" . }}-http/auth/
    {{- end -}}
  {{- else -}}
  {{ required "A valid configuration.KEYCLOAK_SERVER_URL or installKeyloak: true is required!" .Values.configuration.KEYCLOAK_SERVER_URL }}
  {{- end -}}
{{- end -}}

{{/*
Get or use internal keycloak url
*/}}
{{- define "annotationlab.keycloak.internal_url" -}}
  {{- if .Values.configuration.KEYCLOAK_SERVER_URL -}}
    {{ .Values.configuration.KEYCLOAK_SERVER_URL }}
  {{- else if .Values.installKeycloak -}}
http://{{ include "annotationlab.keycloak.fullname" . }}-http/auth/
  {{- else -}}
  {{ required "A valid configuration.KEYCLOAK_SERVER_URL or installKeyloak: true is required!" .Values.configuration.KEYCLOAK_SERVER_URL }}
  {{- end -}}
{{- end -}}

{{/*
Get or use defined keycloak admin username
*/}}
{{- define "annotationlab.keycloak.username" -}}
{{- if .Values.configuration.KEYCLOAK_USERNAME -}}
{{ .Values.configuration.KEYCLOAK_USERNAME }}
{{- else -}}
{{ .Values.keycloak.secrets.admincreds.stringData.user }}
{{- end -}}
{{- end -}}

{{/*
Get or use defined keycloak admin password
*/}}
{{- define "annotationlab.keycloak.password" -}}
{{- if .Values.configuration.KEYCLOAK_PASSWORD -}}
{{ .Values.configuration.KEYCLOAK_PASSWORD }}
{{- else -}}
{{ .Values.keycloak.secrets.admincreds.stringData.password }}
{{- end -}}
{{- end -}}


{{/*
Get or use defined postgres credentials
*/}}
{{- define "annotationlab.annotationdb.connectionString" -}}
{{- if .Values.configuration.DATABASE_CONNECTION_STRING -}}
{{ .Values.configuration.DATABASE_CONNECTION_STRING }}
{{- else -}}
{{- if .Values.installPostgresql -}}
postgresql://{{ .Values.postgresql.postgresqlUsername }}:{{ .Values.postgresql.postgresqlPassword }}@{{ include "annotationlab.postgresql.fullname" . }}/{{ .Values.postgresql.postgresqlDatabase }}
{{- else -}}
{{ required "A valid configuration.DATABASE_CONNECTION_STRING or installPostgresql: true is required!" .Values.configuration.DATABASE_CONNECTION_STRING}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get or use defined airflow postgres credentials
*/}}
{{- define "annotationlab.airflowdb.connectionString" -}}
{{- if .Values.configuration.AIRFLOWDB_CONNECTION_STRING -}}
{{ .Values.configuration.AIRFLOWDB_CONNECTION_STRING }}
{{- else -}}
postgresql://{{ .Values.airflow.postgresql.postgresqlUsername }}:{{ .Values.airflow.postgresql.postgresqlPassword }}@{{ include "annotationlab.airflow.postgresql.fullname" . }}/{{ .Values.airflow.postgresql.postgresqlDatabase }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "annotationlab.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
