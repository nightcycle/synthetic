#!/usr/bin/env bash
package_suffix=$1
build_focus=$2
is_live=$3

for init_file in $(find "src/Util" -name "init.luau"); do
	# if the file is src/Util/init.luau continue
	if [[ "$init_file" == "src/Util/init.luau" ]]; then
		continue
	fi

	echo "$init_file"
	# replace the file content with 'return require(script:WaitForChild("$build_focus"))'
	echo 'return require(script:WaitForChild("'${build_focus}'"))' > "$init_file"
done

for init_file in $(find "src/Component" -name "init.luau"); do
	echo "$init_file"
	# replace the file content with 'return require(script:WaitForChild("$build_focus"))'
	echo 'return require(script:WaitForChild("'${build_focus}'"))' > "$init_file"
done

selene src
luau-lsp analyze --sourcemap="sourcemap.json" --ignore="Packages/**" --ignore="**/Packages/**" --ignore="*.spec.luau" --ignore="out/**" --flag:LuauTypeInferIterationLimit=0 --flag:LuauCheckRecursionLimit=0 --flag:LuauTypeInferRecursionLimit=0 --flag:LuauTarjanChildLimit=0 --flag:LuauTypeInferTypePackLoopLimit=0 --flag:LuauVisitRecursionLimit=0 --definitions=types/globalTypes.d.lua src

package_full_name="nightcycle/synthetic-$package_suffix"
sed -i "s#name = \".*\"#name = \"$package_full_name\"#" wally.toml

if [[ "$is_live" == "true" ]]; then
	wally publish
fi
