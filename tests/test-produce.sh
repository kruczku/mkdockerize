#!/bin/bash
#A happy path written in bash, as the program interface is mkdockerize.sh
set -e
source `pwd`/tests/helpers.cfg

prepare_test_data()

echo "Producing mkdocs tarball... " 
./mkdockerize.sh produce --docs-dir=$TMP_DIR > /tmp/test.tar.gz

printf "DONE\nTesting if produced file is correct... "
file /tmp/test.tar.gz | grep 'gzip compressed data'

printf "DONE\nTesting for index.html in root file... "
LINES=`tar -ztvf /tmp/test.tar.gz | grep '\./index.html' | wc -l`
STATUS=$(( $LINES == 1 ? 0 : 1 ))
printf "DONE\n"

cleanup()

echo "Testing process completed, exiting with status: $STATUS"
exit $STATUS