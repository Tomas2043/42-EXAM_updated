#!/bin/bash

ASSIGN='broken_gnl'
index=0

if [ -e .system/grading/traceback ]; then
    rm .system/grading/traceback
fi

cat > .system/grading/gnl_main.c << 'EOF'
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
char *get_next_line(int fd);
int main(void)
{
    char *line;
    while ((line = get_next_line(0)) != NULL)
    {
        printf("%s", line);
        free(line);
    }
    return 0;
}
EOF

run_test() {
    local bufsize="$1"
    local testfile="$2"

    gcc -Wall -Wextra -Werror -D BUFFER_SIZE="$bufsize" \
        -o .system/grading/source \
        .system/grading/get_next_line.c \
        .system/grading/gnl_main.c 2>/dev/null

    gcc -Wall -Wextra -Werror -D BUFFER_SIZE="$bufsize" \
        -o .system/grading/final \
        "rendu/$ASSIGN/get_next_line.c" \
        .system/grading/gnl_main.c 2>.system/grading/.dev
    if [ $? -ne 0 ]; then
        echo "----------------8<-------------[ START TEST " >> .system/grading/traceback
        printf "        ❌ COMPILATION ERROR (BUFFER_SIZE=%s)\n" "$bufsize" >> .system/grading/traceback
        cat .system/grading/.dev >> .system/grading/traceback
        echo "----------------8<------------- END TEST ]" >> .system/grading/traceback
        rm -f .system/grading/source .system/grading/final .system/grading/.dev .system/grading/gnl_main.c
        mv .system/grading/traceback traceback
        exit 1
    fi

    .system/grading/source < "$testfile" | cat -e > .system/grading/sourcexam
    .system/grading/final  < "$testfile" | cat -e > .system/grading/finalexam 2>/dev/null

    DIFF=$(diff .system/grading/sourcexam .system/grading/finalexam)
    if [ "$DIFF" != "" ]; then
        index=$((index + 1))
        echo "----------------8<-------------[ START TEST " >> .system/grading/traceback
        printf "        💻 TEST: get_next_line with BUFFER_SIZE=%s on '%s'\n" "$bufsize" "$testfile" >> .system/grading/traceback
        printf "        🗝 EXPECTED OUTPUT:\n" >> .system/grading/traceback
        cat .system/grading/sourcexam >> .system/grading/traceback
        printf "        🔎 YOUR OUTPUT:\n" >> .system/grading/traceback
        cat .system/grading/finalexam >> .system/grading/traceback
        echo "----------------8<------------- END TEST ]" >> .system/grading/traceback
    fi
    rm -f .system/grading/source .system/grading/final \
          .system/grading/sourcexam .system/grading/finalexam .system/grading/.dev
}

printf 'Line 1\nLine 2\nLine 3\n'          > /tmp/gnl_test1.txt
printf 'Single line\n'                     > /tmp/gnl_test2.txt
printf 'Has empty\n\nlines here\n'         > /tmp/gnl_test3.txt
printf 'No newline at end'                 > /tmp/gnl_test4.txt
truncate -s 0 /tmp/gnl_test5.txt

run_test 3    /tmp/gnl_test1.txt
run_test 1    /tmp/gnl_test2.txt
run_test 42   /tmp/gnl_test3.txt
run_test 10   /tmp/gnl_test4.txt
run_test 1232 /tmp/gnl_test5.txt

rm -f /tmp/gnl_test*.txt .system/grading/gnl_main.c

if [ $index -eq 0 ]; then
    touch .system/grading/passed
else
    mv .system/grading/traceback traceback
fi
