# Setup

1. Edit `copy_scripts.sh` to point to your Lightroom Scripts path and run it (`./copy_scripts.sh`) (the scripts folder may not exist, it will be created)
2. Edit `rename_files.sh` to point to a folder that the tether software stores photos in, and to a target folder within lightroom
3. Restart lightroom to make the scripts appear on the menu bar, to the right of 'help'

# Usage
1. Take 3 photos in the order flatfield, colorchecker, main
2. Run `osascript import.scpt session number` where `session` is a folder in lightroom (**make sure this exists and is the only selected folder in lightroom**) and `number` is the number of the photographed painting
3. Wait for about a minute as the profile is generated, lightroom restarts and the profile is applied

# Note
For some reason this doesn't work if in Lightroom you have a filter on. On exporting the profile it gets confused and thinks there are multiple photos selected. I have no idea why.

Also, in applying the profile this way, it doesn't show up in the profile under the Basic section in developer mode, but it is actually applied. The difference can be seen, and it is noted in the edit history.

# References

I found out about the existance of scripting for Lightroom [here](https://www.photofacts.nl/fotografie/rubriek/software/je-workflow-verbeteren-met-je-eigen-lightroom-scripts.asp), which also has some useful starting scripts.

The copy to clipboard functionality in Lua was adapted from [here](https://gist.github.com/AndrewHazelden/b9909520490624305183f7c8f77368a2), which also has implementations for other operating systems.

