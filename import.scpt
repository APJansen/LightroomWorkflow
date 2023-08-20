property PROFILE_FOLDER : "/Users/aronjansen/Library/Application Support/Adobe/CameraRaw/CameraProfiles"

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

    -- Step 3: Fill in and click through the export dialog.
    delay 7
    tell application "System Events"
        tell process "Adobe Lightroom Classic"
            set frontWindow to front window
            
            try
                set theValue to value of text field 1 of scroll area 2 of frontWindow
                if theValue is "Untitled profile" then
                    set focused of text field 1 of scroll area 2 of frontWindow to true
                    delay 1
                    keystroke (the clipboard)
                    keystroke return
                end if
            on error errorMessage
                log "Error setting text field: " & errorMessage
            end try
        end tell
    end tell

    -- Step 4: Wait until profile is created and restart lightroom
    -- Wait for the profile file to be created
    set targetFile to PROFILE_FOLDER & "/" & painting_number & ".dcp"
    set fileExists to false
    repeat until fileExists
        delay 0.5
        set fileExists to (do shell script "[ -f " & quoted form of targetFile & " ] && echo 'true' || echo 'false'") is "true"
    end repeat
    delay 0.5
    -- Press enter to close the profile export confirmation
    tell application "System Events"
        tell process "Adobe Lightroom Classic"
            keystroke return
        end tell
    end tell
    -- Restart Lightroom
    tell application "Adobe Lightroom Classic"
        quit
        delay 5
        activate
        delay 5
    end tell
    -- Finally run the '2 - apply profile' script
    tell application "System Events"
        tell process "Adobe Lightroom Classic"
            set numOfMenuItems to count menu bar items of menu bar 1
            tell menu bar item numOfMenuItems of menu bar 1
                click
                tell menu 1
                    click menu item "2 - apply profile"
                end tell
            end tell
        end tell
    end tell
    return
end run
