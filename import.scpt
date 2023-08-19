on run argv
    -- Check if the right number of arguments are passed.

    if (count of argv) is not 2 then
        display dialog "This script requires two arguments: target_folder and painting_number." buttons {"OK"} default button 1
        return
    end if

    set target_folder to item 1 of argv
    set painting_number to item 2 of argv

    -- Step 1: Execute your Bash script with the arguments.
    do shell script "./rename_files.sh " & target_folder & " " & painting_number

    -- activate Lightroom and wait
    tell application "Adobe Lightroom Classic"
        activate
        delay 1
    end tell

    -- Step 2: Simulate keystrokes or actions to run your Lightroom script.
    tell application "System Events"
        tell process "Adobe Lightroom Classic"
            set numOfMenuItems to count menu bar items of menu bar 1
            tell menu bar item numOfMenuItems of menu bar 1
                click
                tell menu 1
                    click menu item "1 - import photos, export profile, start develop"
                end tell
            end tell
        end tell
    end tell
end run

