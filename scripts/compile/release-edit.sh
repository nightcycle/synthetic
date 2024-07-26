#!/usr/bin/env bash
build_focus="ColdFusion"
component_dir_path="src/Component"
# for each descendant file under component_dir_path named "init.luau", print the path
for init_file in $(find $component_dir_path -name "init.luau"); do
	echo "$init_file"
	# replace the file content with 'return require(script:WaitForChild("$build_focus"))'
	echo 'return require(script:WaitForChild("'${build_focus}'"))' > "$init_file"
	break
done

