#!/bin/bash
#A happy path written in bash, as the program interface is mkdockerize.sh
set -e

#Putting testing data in temp path, since the test can be run locally 
TMP_DIR=/tmp/mkdocs-master
printf "Downloading mkdocs master.zip for testing... "
curl -sL https://github.com/mkdocs/mkdocs/archive/master.zip > $TMP_DIR.zip
printf "DONE\n"
printf "Preparing test data to be served... " 
tar -C /tmp -xf $TMP_DIR.zip 
cp $TMP_DIR/requirements/project.txt $TMP_DIR/requirements/docs.txt
printf "DONE\n"
printf "Producing mkdocs tarball... " 
./mkdockerize.sh produce --docs-dir=$TMP_DIR > /tmp/test.tar.gz
printf "DONE\n"
printf "Serving produced file... " 
cat /tmp/test.tar.gz | nohup ./mkdockerize.sh serve /tmp/test.log &> /tmp/test.out &
attempt_counter=0
max_attempts=5
#unfortunately defaulted to good old sleep, as mkdocs serve takes some time to rise
until docker logs mkdocs-serve 2>&1 | grep -q Serving; 
do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Did not serve properly "
    #   cat /tmp/test.out
      exit 1
    fi
    printf '.'
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done
printf "DONE\n"
printf "Checking if the served website has MDocs tag... "
#Mkdocs inputs 
LINES=`curl -Ss localhost:8000 | grep 'MkDocs version' | wc -l`
STATUS=$(( $LINES == 0 ? 1 : 0 ))
printf "DONE\n"
printf "Cleaning up... "
docker stop mkdocs-serve
rm -rf $TMP_DIR $TMP_DIR.zip /tmp/test.tar.gz
printf "DONE\n"
echo "Testing process completed, exiting with status: $STATUS"
exit $STATUS