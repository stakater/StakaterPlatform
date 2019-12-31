#! /bin/sh
# NOTE: These tests require shunit2 to be installed
testJenkinsURL() {
  x=$(curl -IL https://jenkins-delivery.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}

testNexusURL() {
  x=$(curl -Is https://nexus-delivery.DOMAIN 2>/dev/null | head -n 1 | cut -d ' ' -f2)
  assertEquals 200 $x
}


# Load shUnit2.
. /usr/share/shunit2/shunit2
