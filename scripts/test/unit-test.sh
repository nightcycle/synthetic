#!/usr/bin/env bash
run-in-roblox --place scene/main/build.rbxl --script "scripts/test/test-runner.lua" > tests/unit-test.txt
failure_count=$(grep -o -w "failure" "tests/unit-test.txt" | wc -l)
success_count=$(grep -o -w "success" "tests/unit-test.txt" | wc -l)
skip_count=$(grep -o -w "skipped" "tests/unit-test.txt" | wc -l)
test_count=$((failure_count + success_count))
if [ $skip_count -ne 0 ]; then
	echo "unit-test results: ${success_count}/${test_count}, ${failure_count} failed, ${skip_count} skipped"
else
	echo "unit-test results: ${success_count}/${test_count}, ${failure_count} failed"
fi
