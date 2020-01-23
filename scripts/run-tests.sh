#!/bin/bash

# GLOBAL VARIABLES
ITERATIONS=1
TOTAL_ITERATIONS=3
SLEEP_DURATION=300  # duration in seconds

echo "3 iterations will be done each with delay of 5 minutes"
until [ $ITERATIONS -gt $TOTAL_ITERATIONS ]
do
    echo "#############"
    echo "Iteration # $ITERATIONS" 
    echo "#############"

    # iterating over the files that exists in the tests folder
    touch tests-output.txt
    for file in ./scripts/tests/* ; do \
        # executing the test scripts and appending the resilt in the tests-output.txt file.
        ${file} &>> tests-output.txt; \
    done

    # check whether the tests-output.txt file contains the ERROR string in it.
    # If ERROR strings exists it means the tests weren't executed correctly and
    # we will retry after SLEEP_DURATION seconds. If tests executed correctly we
    # will break the condition.

    if grep -q ERROR 'tests-output.txt'; then \
        echo "ERROR WHILE EXECUTING TESTS";
    else
        echo "TESTS EXECUTED SUCCESSFULLY";
        # removing the tests output file
        rm tests-output.txt || true
        break;
    fi
    cat tests-output.txt || true
    # removing the tests output file
    rm tests-output.txt || true
    

    if [[ $ITERATIONS != $TOTAL_ITERATIONS ]]
    then
        sleep $SLEEP_DURATION
    fi

    # incrementing the ITERATION variable
    ITERATIONS=$[$ITERATIONS+1]
done
