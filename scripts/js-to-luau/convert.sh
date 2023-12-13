#!/usr/bin/env bash
js_to_lua="C:/Users/coyer/js-to-lua"
target_dir="C:/Users/coyer/material-ui/packages/mui-material"
synthetic="C:/Users/coyer/Documents/GitHub/synthetic"
out="${synthetic}/src/mui-test"

"${js_to_lua}/dist/apps/convert-js-to-lua/index.js" --input "${target_dir}/src/Badge/index.js" --output $out
