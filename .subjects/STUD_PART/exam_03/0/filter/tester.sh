#!/bin/bash

FILE='filter.c'
ASSIGN='filter'

if [ -e .system/grading/traceback ]; then
    rm .system/grading/traceback
fi

cd .system/grading

gcc -o source "$FILE" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Internal error: reference failed to compile" >> traceback
    cd ../..
    mv .system/grading/traceback traceback
    exit 1
fi

gcc -o final "../../rendu/$ASSIGN/$FILE" 2>.dev
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

check_test() {
    local input="$1"
    local arg="$2"
    printf '%s' "$input" | ./source "$arg" | cat -e > sourcexam
    printf '%s' "$input" | ./final "$arg" | cat -e > finalexam 2>/dev/null
    DIFF=$(diff sourcexam finalexam)
    if [ "$DIFF" != "" ]; then
        echo "----------------8<-------------[ START TEST " >> traceback
        printf "        💻 TEST: printf '%s' | ./filter \"%s\"\n" "$input" "$arg" >> traceback
        printf "        🗝 EXPECTED OUTPUT:\n" >> traceback
        cat sourcexam >> traceback
        printf "        🔎 YOUR OUTPUT:\n" >> traceback
        cat finalexam >> traceback
        echo "----------------8<------------- END TEST ]" >> traceback
        rm -f source final sourcexam finalexam .dev
        cd ../..
        mv .system/grading/traceback traceback
        exit 1
    fi
}

check_test "abcdefaaaabcdeabcabcdabc" "abc"
check_test "ababcabababc" "ababc"
check_test "bonjour world bonjour universe" "bonjour"
check_test "hello world" "xyz"
check_test "abcabc" "abc"
check_test "aaa" "a"
check_test "$(printf 'line1\ntest line2\ntest line3')" "test"
check_test "this is a very long pattern to test replacement" "very long pattern"

./final 2>/dev/null
if [ $? -eq 0 ]; then
    echo "----------------8<-------------[ START TEST " >> traceback
    printf "        💻 TEST: ./filter (no args)\n" >> traceback
    printf "        ❌ Should return non-zero exit code, returned 0\n" >> traceback
    echo "----------------8<------------- END TEST ]" >> traceback
    rm -f source final sourcexam finalexam .dev
    cd ../..
    mv .system/grading/traceback traceback
    exit 1
fi

rm -f source final sourcexam finalexam .dev
cd ../..
touch .system/grading/passed
