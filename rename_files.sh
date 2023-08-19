#!/bin/bash

# Usage: ./rename_files.sh <target_folder> <number> [directory]
# Default directory is /Users/aronjansen/Documents/fotos_temp

TETHER_DIR="/Users/aronjansen/Documents/fotos_temp"
TARGET_DIR="/Users/aronjansen/Dropbox/persoonlijk/fotos/kunstKoeno/sessies"

# Check if the number of arguments is correct
if [ $# -lt 2 ]; then
    echo "Usage: ./rename_files.sh <target_folder> <number> [directory]"
    exit 1
fi

target_folder="$1"
number="$2"
directory="${3:-$TETHER_DIR}"


target_directory="$TARGET_DIR/$target_folder"

# Create target directory if it doesn't exist
if [ ! -d "$target_directory" ]; then
    mkdir -p "$target_directory"
fi

# List all files in directory and sort them by modification time
files=$(ls -t "$directory")

# Convert the string of filenames into an array
files_array=($files)

# Check if there are at least 3 files
if [ ${#files_array[@]} -lt 3 ]; then
    echo "There are less than 3 files in the directory."
    exit 1
fi

# Define new names
names=("$number" "$number - colorchecker" "$number - flatfield")

# Rename the 3 most recently added files and move them to target_directory
for i in {0..2}; do
    file_extension="${files_array[$i]##*.}"  # Extract the file extension
    new_name="${names[$i]}.$file_extension"
    old_path="$directory/${files_array[$i]}"
    new_path="$target_directory/$new_name"
    mv "$old_path" "$new_path"
    echo "Renamed ${files_array[$i]} to $target_folder/$new_name"
done
