#! /bin/bash

lein test
if [ $? -ne 0 ]; then
    exit $?
fi

echo
echo Now running end-to-end tests:

LEDGER="test/data/ledger.dat"

rm -f test/data/*.out

echo -n "testing bb.csv... "
lein run -l $LEDGER -f test/data/bb.csv -sa 3 -sz 2 -D 'yyyy/MM/dd' \
     -r 3 -m 4 -t '%9!%1 %6 %7 %8' -a 'Assets:BB Account' -c HUF > test/data/bb.out
diff -u test/data/bb.out test/data/bb.ref-out >/dev/null
if [ $? -ne 0 ]; then
    echo "FAIL, inspect bb.out!"
else
    rm test/data/bb.out
    echo "OK"
fi

echo -n "testing ica.csv... "
lein run -l $LEDGER -f test/data/ica.csv -F ';' -sa 1 -m 4 -t '%1' \
	-a 'Assets:ICA Account' > test/data/ica.out
diff -u test/data/ica.out test/data/ica.ref-out >/dev/null
if [ $? -ne 0 ]; then
    echo "FAIL, inspect ica.out!"
else
    rm test/data/ica.out
    echo "OK"
fi

echo -n "testing seb.csv... "
lein run -l $LEDGER -f test/data/seb.csv -sa 5 -r 2 -m 4 -t '%3' \
     -a 'Assets:SEB Account' > test/data/seb.out
diff -u test/data/seb.out test/data/seb.ref-out >/dev/null
if [ $? -ne 0 ]; then
    echo "FAIL, inspect seb.out!"
else
    rm test/data/seb.out
    echo "OK"
fi
