#!/usr/bin/env bash
wally-update minor
wally install
rojo sourcemap dev.project.json --output sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages