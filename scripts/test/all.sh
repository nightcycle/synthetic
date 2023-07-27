#!/usr/bin/env bash
# sh scripts/test/download.sh
# sh scripts/test/unit-test.sh
sh scripts/test/lsp.sh src out
# sh scripts/test/lsp.sh out src
sh scripts/test/selene.sh src
# sh scripts/test/selene.sh out
