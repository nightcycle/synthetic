#!/usr/bin/env bash
content_dir_path=$1
ignore_dir=$2

luau-lsp analyze $content_dir_path \
--sourcemap=sourcemap.json \
--ignore="Packages/**" \
--ignore="**/Packages/**" \
--ignore="*.spec.luau" \
--ignore="${ignore_dir}/**" \
--flag:LuauTypeInferIterationLimit=0 \
--flag:LuauCheckRecursionLimit=0 \
--flag:LuauTypeInferRecursionLimit=0 \
--flag:LuauTarjanChildLimit=0 \
--flag:LuauTypeInferTypePackLoopLimit=0 \
--flag:LuauVisitRecursionLimit=0 \
--flag:LuauParseDeclareClassIndexer=true \
--definitions=types/globalTypes.d.lua \
 > tests/lsp/$content_dir_path.txt 2>&1
echo "${content_dir_path} lsp errors: $(wc -l < tests/lsp/${content_dir_path}.txt)"
