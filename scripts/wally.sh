#!/bin/bash
# A sample Bash script
echo Starting Wally Update	# This is a comment, too!
wally-update major
wally install
rojo sourcemap test.project.json --output sourcemap.json
wally-Package-types --sourcemap sourcemap.json Packages
echo Finishing Wally Update	# This is a comment, too!