#!/bin/bash

cd `dirname $0`
CWD="`pwd`"

curl "http://127.0.0.1:8484/test/run.cfm?reporter=text"

exitcode=$(<.exitcode)
rm -f .exitcode

exit $exitcode