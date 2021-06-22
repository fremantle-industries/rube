FROM nginx:1.20.0-alpine
CMD sh -c 'envsubst \
  "\$MONITOR_HOST \$WORKBENCH_HOST \$GRAFANA_HOST \$PROMETHEUS_HOST \$HTTP_PORT" \
  < /etc/nginx/templates/nginx.conf \
  > /etc/nginx/nginx.conf \
  && nginx -g "daemon off;"'
