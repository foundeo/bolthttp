#!/bin/bash

cd `dirname $0`/test
CWD="`pwd`"

curl http://127.0.0.1:8484/test/run.cfm

exitcode=$(<.exitcode)
rm -f .exitcode

exit $exitcode