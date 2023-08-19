# Setup

1. Edit `copy_scripts.sh` to point to your Lightroom Scripts path and run it (`./copy_scripts.sh`) (the scripts folder may not exist, it will be created)
2. Edit `rename_files.sh` to point to a folder that the tether software stores photos in, and to a target folder within lightroom
3. Restart lightroom to make the scripts appear on the menu bar, to the right of 'help'
4. In the grid view, turn on a filter for the highres keyword, and lock it

# Usage
1. Take 3 photos in the order flatfield, colorchecker, main
2. Run `osascript import.scpt session number` where `session` is a folder in lightroom and `number` is the number of the photographed painting
3. Wait until the dialog box is gone (filled automatically), you end in develop mode, so straighten out the photo using guided transform, and crop it.
5. Restart lightroom (this is necessary for it to see the new profile), and run the second script to apply the profile
6. You end in develop mode where manual tweaks can be made.

Note step 2 is an apple script that first runs the bash script and then navigates the Lightroom menu to start the importing script.

# References

I found out about the existance of scripting for Lightroom [here](https://www.photofacts.nl/fotografie/rubriek/software/je-workflow-verbeteren-met-je-eigen-lightroom-scripts.asp), which also has some useful starting scripts.

The copy to clipboard functionality in Lua was adapted from [here](https://gist.github.com/AndrewHazelden/b9909520490624305183f7c8f77368a2), which also has implementations for other operating systems.

