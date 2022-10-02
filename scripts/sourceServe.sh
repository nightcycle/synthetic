#!/bin/bash
# A sample Bash script
echo Starting Sourcemap Update	# This is a comment, too!
rojo sourcemap test.project.json --output sourcemap.json
echo Restarting Rojo
rojo serve test.project.json
echo Done