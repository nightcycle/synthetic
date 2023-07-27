#!/usr/bin/env bash
content_dir_path=$1
selene $content_dir_path > tests/selene/$content_dir_path.txt
error_count=$(grep -o -w "error" "tests/selene/${content_dir_path}.txt" | wc -l)
warn_count=$(grep -o -w "warning" "tests/selene/${content_dir_path}.txt" | wc -l)
echo "${content_dir_path} selene errors: ${error_count}, warnings: ${warn_count}"