{{- define "transcoder.workload" -}}
workload:
  transcoder:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      hostNetwork: false
      containers:
        transcoder:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.transcoderRunAs.user }}
            runAsGroup: {{ .Values.transcoderRunAs.group }}
          command:
            - tail
            - -f
            - /dev/null
          env:
            TZ: {{ .Values.TZ }}
          {{ with .Values.transcoderConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              value: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: false
            readiness:
              enabled: false
            startup:
              enabled: false

{{/* Service - not needed for this app but required by some TrueNAS versions */}}
service:
  transcoder:
    enabled: false

{{/* Persistence */}}
persistence:
  config:
    enabled: true
    {{- if eq .Values.transcoderStorage.config.type "hostPath" }}
    type: hostPath
    hostPath: {{ .Values.transcoderStorage.config.hostPathConfig.hostPath }}
    {{- else }}
    type: {{ .Values.transcoderStorage.config.type }}
    datasetName: {{ .Values.transcoderStorage.config.ixVolumeConfig.datasetName }}
    {{- end }}
    targetSelector:
      transcoder:
        transcoder:
          mountPath: /config
  media:
    enabled: true
    type: hostPath
    hostPath: {{ .Values.transcoderStorage.media.hostPathConfig.hostPath }}
    targetSelector:
      transcoder:
        transcoder:
          mountPath: /mnt/media
  {{- range $idx, $storage := .Values.transcoderStorage.additionalStorages }}
  {{ printf "transcoder-%v" (int $idx) }}:
    enabled: true
    {{- if eq $storage.type "hostPath" }}
    type: hostPath
    hostPath: {{ $storage.hostPathConfig.hostPath }}
    {{- else }}
    type: {{ $storage.type }}
    datasetName: {{ $storage.ixVolumeConfig.datasetName }}
    {{- end }}
    targetSelector:
      transcoder:
        transcoder:
          mountPath: {{ $storage.mountPath }}
          readOnly: {{ $storage.readOnly }}
  {{- end }}
{{- end -}}