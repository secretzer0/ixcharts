{{- define "transcoder.workload" -}}
workload:
  transcoder:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      containers:
        transcoder:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.transcoderRunAs.user }}
            runAsGroup: {{ .Values.transcoderRunAs.group }}
          command:
            - /bin/sh
            - -c
            - "tail -f /dev/null"
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
      initContainers:
      {{- include "ix.v1.common.app.permissions" (dict "containerName" "01-permissions"
                                                        "UID" (include "ix.v1.common.helper.makeIntOrNoop" .Values.transcoderRunAs.user)
                                                        "GID" (include "ix.v1.common.helper.makeIntOrNoop" .Values.transcoderRunAs.group)
                                                        "mode" "check"
                                                        "type" "install") | nindent 8 }}
{{/* Service */}}
service:
  transcoder:
    enabled: false

{{/* Persistence */}}
persistence:
  tmp:
    enabled: true
    type: emptyDir
    targetSelector:
      transcoder:
        transcoder:
          mountPath: /tmp
  {{- range $idx, $storage := .Values.transcoderStorage.additionalStorages }}
  {{ printf "transcoder-%v:" (int $idx) }}
    enabled: true
    {{- include "ix.v1.common.app.storageOptions" (dict "storage" $storage) | nindent 4 }}
    targetSelector:
      transcoder:
        transcoder:
          mountPath: {{ $storage.mountPath }}
        {{- if and (eq $storage.type "ixVolume") (not ($storage.ixVolumeConfig | default dict).aclEnable) }}
        01-permissions:
          mountPath: /mnt/directories{{ $storage.mountPath }}
        {{- end }}
  {{- end }}

{{- end -}}
