#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testAlertmanagerURL() {
  x=$(curl -X GET -IL https://alertmanager-monitoring.workshop.stakater.com 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testGrafanaURL() {
  x=$(curl -X GET -Is https://grafana-monitoring.workshop.stakater.com/login 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testPrometheusURL() {
  x=$(curl -X GET -Is https://prometheus-monitoring.workshop.stakater.com/alerts 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
