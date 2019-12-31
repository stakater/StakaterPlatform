#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testJaegerURL() {
  x=$(curl -IL https://jaeger-tracing.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

# Load shUnit2.
. /usr/share/shunit2/shunit2
