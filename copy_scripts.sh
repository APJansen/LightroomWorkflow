# Description: Copies the scripts to the Lightroom scripts directory
# Usage: ./copy_scripts.sh
# Note: This script is intended to be run from the directory where the scripts are located

# replace with your own path
LR_dir="/Users/aronjansen/Library/Application Support/Adobe/Lightroom/Scripts/"
mkdir -p "$LR_dir"
# copy the scripts
for script in *.lua
do
    cp "$script" "$LR_dir"
done
