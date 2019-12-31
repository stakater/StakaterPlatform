#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testJenkinsURL() {
  x=$(curl -X GET -IL https://jenkins-delivery.workshop.stakater.com 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  
  assertEquals 403 $x
}

testNexusURL() {
  x=$(curl -X GET -Is https://nexus-delivery.workshop.stakater.com 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
