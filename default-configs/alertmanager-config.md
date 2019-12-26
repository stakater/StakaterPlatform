# ALertmanager Config
Following YAML config represents an example for configuring Alertmanager to send infra and apps alerts on Slack channels. Alertmanger can be configured by editing the following file as per required and providing this config (in Base64 encoded string) as an Environment variable `BASE64_ENCODED_ALERTMANAGER_CONFIG` in the deployment pipeline

```
global:
  resolve_timeout: 5m
inhibit_rules:
    source_match:
      alertname: 'Watchdog'
    equal: ['prometheus']
receivers:
- name: alerts-null
- name: default-infra-alerts
  slack_configs:
  - api_url: https://hooks.slack.com/services/AAAAAA/BBBBBBBBB/CCCCCCCCCCCC
    channel: '#stakater-platform-infra-alerts'
    send_resolved: true
    text: |2-

      {{ range .Alerts }}
        *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`

        *Description:* {{ .Annotations.description }}

        *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:> *Runbook:* <{{ .Annotations.runbook }}|:spiral_note_pad:>

        *Details:*

        {{ range .Labels.SortedPairs }} *{{ .Name }}:* `{{ .Value }}`

        {{ end }}

      {{ end }}
    title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] Prometheus Event Notification'
    title_link: |2
      https://alertmanager-monitoring.DOMAIN

- name: apps-alerts
  slack_configs:
  - api_url: https://hooks.slack.com/services/AAAAAA/BBBBBBBBB/CCCCCCCCCCCC
    channel: '#stakater-platform-apps-alerts'
    send_resolved: true
    text: |2-

      {{ range .Alerts }}
        *Alert:* {{ .Annotations.summary }} - `{{ .Labels.severity }}`

        *Description:* {{ .Annotations.description }}

        *Graph:* <{{ .GeneratorURL }}|:chart_with_upwards_trend:> *Runbook:* <{{ .Annotations.runbook }}|:spiral_note_pad:>

        *Details:*

        {{ range .Labels.SortedPairs }} *{{ .Name }}:* `{{ .Value }}`

        {{ end }}

      {{ end }}
    title: '[{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing| len }}{{ end }}] Prometheus Event Notification'
    title_link: |2

      https://alertmanager-monitoring.DOMAIN
route:
  group_by:
  - alertname
  - cluster
  - service
  group_interval: 5m
  group_wait: 30s
  repeat_interval: 1h
  receiver: default-infra-alerts
  routes:
  - match:
      kind: apps
    receiver: apps-alerts
  - match:
      alertname: Watchdog
    receiver: alerts-null  # Stopping Watchdog to send alerts on slack
```