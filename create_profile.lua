-- With 3 photos selected, with names:
-- XXX.rw2
-- XXX - flatfield.rw2
-- XXX - colorchecker.rw2
-- This will copy all the settings from XXX.rw2 and apply it to the other two
-- Then it will copy the number to the clipboard,
-- and open the export dialog for XXX - colorchecker.rw2
-- Finally, it will quit lightroom, as we need to restart it to apply the profile
local LrTasks = import 'LrTasks'
local catalog = import "LrApplication".activeCatalog()
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'

function CopyToClipboard(textString)
  outputDirectory = '/tmp/'
  clipboardTempFile = outputDirectory .. 'ClipboardText.txt'

  -- Create the temp folder if required
  os.execute('mkdir "' .. outputDirectory..'"')

  -- Open up the file pointer for the output textfile
  outClipFile, err = io.open(clipboardTempFile,'w')
  if err then 
    print("[Error Opening Clipboard Temporary File for Writing]")
    return
  end

  outClipFile:write(textString,'\n')

  -- Close the file pointer on the output textfile
  outClipFile:close()

  command = 'pbcopy < "' .. clipboardTempFile .. '"'

  printStatus = false
  if printStatus == 1 or printStatus == true then
    print('[Copy Text to Clipboard Command] ' .. command)
    print('[Clipboard] ' .. textString)
  end
  os.execute(command)
end

LrTasks.startAsyncTask( function()
    local photos = catalog:getTargetPhotos()
    -- check that there are 3 photos selected
    if #photos ~= 3 then
        -- report how many were selected
        LrDialogs.message("Error", "Please select 3 photos, found "..#photos, "critical")
        return
    end
    -- extract the number
    local number = photos[1]:getFormattedMetadata('fileName'):match("^(%d+)")
    -- check that the 3 photos have the same number
    for i, photo in ipairs(photos) do
        local name = photo:getFormattedMetadata('fileName')
        if not name:match("^"..number) then
            LrDialogs.message("Error", "Please select 3 photos with the same number, found "..name, "critical")
            return
        end
    end
    -- and the right suffixes
    local main_photo, colorchecker_photo, flatfield_photo
    for i, photo in ipairs(photos) do
        local name = photo:getFormattedMetadata('fileName')
        if name:match("^"..number.." %- flatfield.rw2") then
            flatfield_photo = photo
        elseif name:match("^"..number.." %- colorchecker.rw2") then
            colorchecker_photo = photo
        elseif name:match("^"..number..".rw2") then
            main_photo = photo
        else
            LrDialogs.message("Error", "Didn't recognise name '"..name.."'", "critical")
            return
        end
    end

    -- copy the settings from the main_photo
    local main_settings = main_photo:getDevelopSettings()
    -- then apply the settings to the other two photos
    -- ask for confirmation
    result = LrDialogs.confirm("Apply settings", "Apply develop settings of\n'"..main_photo:getFormattedMetadata('fileName').."' to \n'"..flatfield_photo:getFormattedMetadata('fileName').."' and \n'"..colorchecker_photo:getFormattedMetadata('fileName').."'?", "Apply", "Cancel", nil, nil)
    if result ~= "ok" then
        return
    end
    flatfield_photo.catalog:withWriteAccessDo("Apply profile", function()
        flatfield_photo:applyDevelopSettings(main_settings)
    end)
    colorchecker_photo.catalog:withWriteAccessDo("Apply profile", function()
        colorchecker_photo:applyDevelopSettings(main_settings)
    end)

    CopyToClipboard(number)

    -- now export with preset on the colorchecker photo
    -- best we can do is open the dialog I think
    catalog:setSelectedPhotos(colorchecker_photo, {})
    colorchecker_photo.openExportDialog()

    -- TODO: wait until it's done and then quit lightroom, as we need to restart it
end)
