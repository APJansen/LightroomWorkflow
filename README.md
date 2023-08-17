# Setup

1. Edit `copy_scripts.sh` to point to your Lightroom Scripts path (the scripts folder may not exist, it will be created)
2. Restart lightroom to make them appear on the menu bar, to the right of 'help'

# Usage
1. Straighten and crop the main photo
2. Select the 3 photos of a painting and run the 'create_profile' script
3. Confirm to copy over modifications
4. in the export dialog copy into the 'DNG Profile Name', the correct name will have been put in clipboard already. (For some reason the pasted text will only show up after clicking elsewhere)
5. Wait until it's finished and reset Lightroom
6. Select the main photo and run the 'apply_profile' script

# References

I found out about the existance of scripting for Lightroom [here](https://www.photofacts.nl/fotografie/rubriek/software/je-workflow-verbeteren-met-je-eigen-lightroom-scripts.asp), which also has some useful starting scripts.

The copy to clipboard functionality in Lua was adapted from [here](https://gist.github.com/AndrewHazelden/b9909520490624305183f7c8f77368a2), which also has implementations for other operating systems.

