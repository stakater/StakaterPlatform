#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testDashboardURL() {
  x=$(curl -X GET -IL https://dashboard-control.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testForecastleURL() {
  x=$(curl -X GET -Is https://forecastle-control.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 307 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
