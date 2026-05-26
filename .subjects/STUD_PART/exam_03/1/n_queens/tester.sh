#!/bin/bash

FILE='n_queens.c'
ASSIGN='n_queens'

bash .system/auto_correc_program.sh $FILE $ASSIGN "2"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "4"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "5"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "6"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "7"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

bash .system/auto_correc_program.sh $FILE $ASSIGN "0"
if [ -e .system/grading/traceback ]; then
    mv .system/grading/traceback .
    exit 1
fi

touch .system/grading/passed
