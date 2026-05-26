#!/bin/bash

FILE='tsp.c'
ASSIGN='tsp'
index=0

if [ -e .system/grading/traceback ]; then
    rm .system/grading/traceback
fi

cd .system/grading

gcc -o source "$FILE" -lm 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Internal error: reference failed to compile" >> traceback
    cd ../..
    mv .system/grading/traceback traceback
    exit 1
fi

gcc -o final "../../rendu/$ASSIGN/$FILE" -lm 2>.dev
if [ $? -ne 0 ]; then
    echo "----------------8<-------------[ START TEST " >> traceback
    printf "        ❌ COMPILATION ERROR\n" >> traceback
    cat .dev >> traceback
    echo "----------------8<------------- END TEST ]" >> traceback
    rm -f source final .dev
    cd ../..
    mv .system/grading/traceback traceback
    exit 1
fi

run_test() {
    local desc="$1"; local input="$2"
    printf '%s' "$input" | ./source | cat -e > sourcexam
    printf '%s' "$input" | ./final  | cat -e > finalexam 2>/dev/null
    DIFF=$(diff sourcexam finalexam)
    if [ "$DIFF" != "" ]; then
        index=$((index + 1))
        echo "----------------8<-------------[ START TEST " >> traceback
        printf "        💻 TEST: %s\n" "$desc" >> traceback
        printf "        🗝 EXPECTED OUTPUT:\n" >> traceback
        cat sourcexam >> traceback
        printf "        🔎 YOUR OUTPUT:\n" >> traceback
        cat finalexam >> traceback
        echo "----------------8<------------- END TEST ]" >> traceback
    fi
    rm -f sourcexam finalexam
}

run_test "square 1x1" "$(printf '1, 1\n0, 1\n1, 0\n0, 0\n')"
run_test "square 0x0" "$(printf '0, 0\n1, 0\n1, 1\n0, 1\n')"
run_test "collinear 4 pts" "$(printf '0, 0\n1, 0\n2, 0\n3, 0\n')"
run_test "sub.txt 3x3 grid" "$(printf '0, 0\n1, 0\n2, 0\n0, 1\n1, 1\n2, 1\n1, 2\n2, 2\n')"
run_test "single point" "$(printf '0, 0\n')"
run_test "two points" "$(printf '0, 0\n1, 1\n')"

rm -f source final .dev
cd ../..

if [ $index -eq 0 ]; then
    touch .system/grading/passed
else
    mv .system/grading/traceback traceback
fi
