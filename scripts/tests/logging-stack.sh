#!/bin/sh
# NOTE: These tests require shunit2 to be installed
testKibanaURL() {
  x=$(curl -X GET -IL https://kibana-logging.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 307 $x
}

testCerebroURL() {
  x=$(curl -X GET -IL https://cerebro-logging.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 307 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
