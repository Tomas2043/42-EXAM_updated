#!/bin/bash

FILE='powerset.c'
ASSIGN='powerset'

bash .system/auto_correc_program.sh $FILE $ASSIGN "5" "1" "2" "3" "4" "5"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "3" "1" "0" "2" "4" "5" "3"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "0" "1" "-1"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "7" "3" "8" "2"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "0" "1" "2" "3"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "12" "5" "2" "1" "8" "4" "3" "7" "11"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

touch .system/grading/passed
