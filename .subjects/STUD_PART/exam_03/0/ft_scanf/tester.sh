#!/bin/bash

FILE='ft_scanf.c'
ASSIGN='ft_scanf'
index=0

if [ -e .system/grading/traceback ]; then
    rm .system/grading/traceback
fi

make_test() {
    local id="$1"; shift
    cat > .system/grading/t${id}.c << EOF
$@
EOF
}

make_test 1 '
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
extern int ft_scanf(const char *, ...);
int main(void) {
    int n = -1; char s[100] = {0}; char c = 63;
    int r = ft_scanf("%d %s %c", &n, s, &c);
    printf("%d %d [%s] [%c]\n", r, n, s, c);
    return 0;
}'

make_test 2 '
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
extern int ft_scanf(const char *, ...);
int main(void) {
    char s1[100] = {0}; char s2[100] = {0};
    int r = ft_scanf("%s %s", s1, s2);
    printf("%d [%s] [%s]\n", r, s1, s2);
    return 0;
}'

make_test 3 '
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
extern int ft_scanf(const char *, ...);
int main(void) {
    int a = 0, b = 0, c = 0;
    int r = ft_scanf("%d %d %d", &a, &b, &c);
    printf("%d %d %d %d\n", r, a, b, c);
    return 0;
}'

make_test 4 '
#include <stdio.h>
#include <stdarg.h>
#include <ctype.h>
extern int ft_scanf(const char *, ...);
int main(void) {
    char c1 = 0, c2 = 0, c3 = 0;
    int r = ft_scanf("%c%c%c", &c1, &c2, &c3);
    printf("%d [%c] [%c] [%c]\n", r, c1, c2, c3);
    return 0;
}'

compile_tests() {
    local src="$1"
    for i in 1 2 3 4; do
        gcc -Wall -Wextra -o ".system/grading/ref_t${i}" ".system/grading/t${i}.c" "$src" 2>/dev/null
    done
}

compile_tests ".system/grading/$FILE"

gcc -Wall -Wextra -o .system/grading/stud_t1 .system/grading/t1.c "rendu/$ASSIGN/$FILE" 2>.system/grading/.dev
if [ $? -ne 0 ]; then
    echo "----------------8<-------------[ START TEST " >> .system/grading/traceback
    printf "        ❌ COMPILATION ERROR\n" >> .system/grading/traceback
    cat .system/grading/.dev >> .system/grading/traceback
    echo "----------------8<------------- END TEST ]" >> .system/grading/traceback
    rm -f .system/grading/t*.c .system/grading/ref_t* .system/grading/.dev
    mv .system/grading/traceback traceback
    exit 1
fi
for i in 2 3 4; do
    gcc -Wall -Wextra -o ".system/grading/stud_t${i}" ".system/grading/t${i}.c" "rendu/$ASSIGN/$FILE" 2>/dev/null
done

run_test() {
    local id="$1"; local desc="$2"; local input="$3"
    printf '%s' "$input" | .system/grading/ref_t${id} | cat -e > .system/grading/srcexam
    printf '%s' "$input" | .system/grading/stud_t${id} | cat -e > .system/grading/finexam 2>/dev/null
    DIFF=$(diff .system/grading/srcexam .system/grading/finexam)
    if [ "$DIFF" != "" ]; then
        index=$((index + 1))
        echo "----------------8<-------------[ START TEST " >> .system/grading/traceback
        printf "        💻 TEST %s: input='%s'\n" "$desc" "$input" >> .system/grading/traceback
        printf "        🗝 EXPECTED OUTPUT:\n" >> .system/grading/traceback
        cat .system/grading/srcexam >> .system/grading/traceback
        printf "        🔎 YOUR OUTPUT:\n" >> .system/grading/traceback
        cat .system/grading/finexam >> .system/grading/traceback
        echo "----------------8<------------- END TEST ]" >> .system/grading/traceback
    fi
    rm -f .system/grading/srcexam .system/grading/finexam
}

run_test 1 "ft_scanf(%d %s %c) / 42 hello a" "42 hello a"
run_test 2 "ft_scanf(%s %s) / first second" "first second"
run_test 3 "ft_scanf(%d %d %d) / 1 2 3" "1 2 3"
run_test 4 "ft_scanf(%c%c%c) / abc" "abc"
run_test 1 "ft_scanf(%d %s %c) / -7 world z" "-7 world z"
run_test 3 "ft_scanf(%d %d %d) / 0 -1 100" "0 -1 100"

rm -f .system/grading/t*.c .system/grading/ref_t* .system/grading/stud_t* .system/grading/.dev

if [ $index -eq 0 ]; then
    touch .system/grading/passed
else
    mv .system/grading/traceback traceback
fi
