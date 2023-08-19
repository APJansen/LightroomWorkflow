# Description: Copies the scripts to the Lightroom scripts directory
# Usage: ./copy_scripts.sh
# Note: This script is intended to be run from the directory where the scripts are located

# The directory where Lightroom reads the scripts from
LR_dir="/Users/aronjansen/Library/Application Support/Adobe/Lightroom/Scripts/"
mkdir -p "$LR_dir"
for script in *.lua
do
    cp "$script" "$LR_dir"
done
