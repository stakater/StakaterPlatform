#!/bin/bash
# NOTE: It requires shunit2 to be installed.

echo -e "\n========= Testing Stakater Endpoints ==========\n"
testIngresses() {
	HOST_NAMES=$(kubectl get ingress --all-namespaces | awk '{print $3}' | grep '\.')
        for HOST_NAME in $HOST_NAMES; do
		echo $HOST_NAME
		# this script works fine but all response code are not 200
		x=$(curl -Is $HOST_NAME 2>/dev/null | head -n 1 | cut -d ' ' -f2)
	        assertEquals 200 $x
        done
}

# Load shUnit2.
. /usr/share/shunit2/shunit2
echo -e "\n========= Testing Ended =========="
