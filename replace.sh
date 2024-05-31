#!/bin/bash

# Check if the dump directory is provided as a command-line argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <dump_directory>"
    exit 1
fi

src_dir=$(pwd)/recovery/root
dump_dir=$1

# Verify if the dump directory exists
if [ ! -d "$dump_dir" ]; then
    echo "Error: Dump directory $dump_dir does not exist."
    exit 1
fi

# Array to store missing files
missing_files=()

# Find all files in the src_dir
find "$src_dir" -type f | while read -r src_file; do
    # Construct the corresponding dump file path
    relative_path="${src_file#$src_dir/}"
    dump_file="$dump_dir/$relative_path"
    
    # Check if the dump file exists
    if [ -f "$dump_file" ]; then
        # Replace the src file with the dump file
        cp "$dump_file" "$src_file"
        echo "Replaced $src_file with $dump_file"
#	 echo "replaced"
	:
    else
#	echo "not found $dump_file"
#	echo "array is $missing_files"
        # Add to the missing files array
        missing_files+=("$dump_file")
#	echo "array is $missing_files" 
    fi
done

# Print all missing files at the end
if [ ${#missing_files[@]} -ne 0 ]; then
    echo "The following files were not found in the dump directory:"
    for file in "${missing_files[@]}"; do
        echo "$file"
    done
else
    echo "All files were successfully replaced."
fi

