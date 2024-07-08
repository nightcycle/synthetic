#!/usr/bin/env bash
source .env/Scripts/Activate
py scripts/compile/run.py
stylua src
rojo sourcemap dev.project.json --output sourcemap.json