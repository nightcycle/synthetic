#!/usr/bin/env bash
package_suffix="cold-fusion"
build_focus="ColdFusion"

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

package_full_name="nightcycle/synthetic-$package_suffix"
sed -i "s#name = \".*\"#name = \"$package_full_name\"#" wally.toml

