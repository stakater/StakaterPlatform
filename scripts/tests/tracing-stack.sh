#!/bin/sh
# NOTE: These tests require shunit2 to be installed
testJaegerURL() {
  x=$(curl -X GET -IL https://jaeger-tracing.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testKialiURL() {
  x=$(curl -X GET -IL https://kiali-tracing.DOMAIN/kiali 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  # 302 url redirection 
  assertEquals 302 $x
}

# Load shUnit2.
. /usr/share/shunit2/shunit2
