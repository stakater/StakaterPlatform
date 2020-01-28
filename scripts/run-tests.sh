#!/bin/bash

# GLOBAL VARIABLES
ITERATIONS_COUNTER=1
TOTAL_ITERATIONS=20
SLEEP_DURATION=60  # duration in seconds

echo "Maximum $TOTAL_ITERATIONS iterations will be done each with delay of 1 minute"
until [ $ITERATIONS_COUNTER -gt $TOTAL_ITERATIONS ]
do
    echo "#############"
    echo "Iteration # $ITERATIONS_COUNTER" 
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
    

    if [[ $ITERATIONS_COUNTER != $TOTAL_ITERATIONS ]]
    then
        sleep $SLEEP_DURATION
    else
        echo "TRIED FOR $ITERATIONS_COUNTER TIMES. TESTS STILL FAILING. FAILING PIPELINE..."
        exit 1
    fi

    # incrementing the ITERATION variable
    ITERATIONS_COUNTER=$[$ITERATIONS_COUNTER+1]
done
