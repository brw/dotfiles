#!/usr/bin/env bash

# Loop over each line of the .tool-versions file
while read -r line; do
	IFS=' ' read -r -a tool_and_versions <<< "$line"
	# Split out the tool name and versions
	tool_name="${tool_and_versions[0]}"
	global_versions=("${tool_and_versions[@]:1}")

  # Loop over each version of the tool name
  for version in $(asdf list $tool_name); do
	  # When version not in `global_versions` array from .tool-versions file
	  if [[ ! " ${global_versions[@]} " =~ " ${version} " ]]; then
		  asdf uninstall $tool_name $version
	  fi
  done
done < ~/.tool-versions
