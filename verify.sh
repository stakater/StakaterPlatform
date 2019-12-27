
echo "\\n========= Testing Stakater Endpoints =========="
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://dashboard-control.DOMAIN" -o /dev/null
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://forecastle-control.DOMAIN" -o /dev/null

curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://kibana-logging.DOMAIN" -o /dev/null
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://cerebro-logging.DOMAIN" -o /dev/null

curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://jenkins-delivery.DOMAIN" -o /dev/null
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://nexus-delivery.DOMAIN" -o /dev/null

curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://alertmanager-monitoring.DOMAIN" -o /dev/null
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://grafana-monitoring.DOMAIN" -o /dev/null
curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://prometheus-monitoring.DOMAIN" -o /dev/null

curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://keycloak-security.DOMAIN" -o /dev/null

curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://jaeger-tracing.DOMAIN" -o /dev/null

echo "========= Testing Ended =========="
