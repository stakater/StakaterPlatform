#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testKibanaURL() {
  x=$(curl -IL https://kibana-logging.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testForecastleURL() {
  x=$(curl -Is https://forecastle-logging.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
