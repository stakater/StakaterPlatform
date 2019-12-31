#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testAlertmanagerURL() {
  x=$(curl -IL https://alertmanager-monitoring.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testGrafanaURL() {
  x=$(curl -Is https://grafana-monitoring.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testPrometheusURL() {
  x=$(curl -Is https://prometheus-monitoring.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
