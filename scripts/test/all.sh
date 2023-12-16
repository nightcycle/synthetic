#!/usr/bin/env bash
# sh scripts/test/download.sh
# sh scripts/test/unit-test.sh
sh scripts/test/lsp.sh src out
# sh scripts/test/lsp.sh out src
selene src
# selene out
