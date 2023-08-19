local LrTasks = import 'LrTasks'
local catalog = import "LrApplication".activeCatalog()
local LrDialogs = import 'LrDialogs'
local LrFileUtils = import 'LrFileUtils'


LrTasks.startAsyncTask( function()
    local photos = AddPhotosFromFolder()
    local number, main_photo, colorchecker_photo, flatfield_photo = findPhotoTypes(photos)
    startProfileExport(number, colorchecker_photo)
end)


-- Add photos from folder to the catalog
-- and returns a list of the photos added
function AddPhotosFromFolder()
    local sources = catalog:getActiveSources()
    -- find the folder
    for _, source in ipairs(sources) do
        if source.getName then
            folder = source
        end
    end

    -- get list of photos already in catalog
    local photos_in_catalog = folder:getPhotos()
    -- now of all files in the folder
    local photos_in_folder = LrFileUtils.files( folder:getPath())
    -- import the new ones
    new_photos = {}
    for photo in photos_in_folder do
        local found = false
        for _, catalog_photo in ipairs(photos_in_catalog) do
            if photo == catalog_photo:getRawMetadata("path") then
                found = true
                break
            end
        end
        if not found then
            if photo:match(".rw2") then
                catalog:withWriteAccessDo("Import", function()
                    catalog:addPhoto(photo)
                end)
                table.insert(new_photos, catalog:findPhotoByPath(photo))
            end
        end
    end
    return new_photos
end


-- Checks if photos have the expected names and returns them in fixed order, along with the number
function findPhotoTypes(photos)
    if #photos ~= 3 then
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
            return nil
        end
    end
    return number, main_photo, colorchecker_photo, flatfield_photo
end


-- Copies the develop settings from main_photo to colorchecker_photo and flatfield_photo
function copySettings(main_photo, colorchecker_photo, flatfield_photo)
    confirmation = LrDialogs.confirm("Apply settings", "Apply develop settings of\n'"..main_photo:getFormattedMetadata('fileName').."' to \n'"..flatfield_photo:getFormattedMetadata('fileName').."' and \n'"..colorchecker_photo:getFormattedMetadata('fileName').."'?", "Apply", "Cancel", nil, nil)
    if confirmation ~= "ok" then
        return
    end

    local main_settings = main_photo:getDevelopSettings()
    flatfield_photo.catalog:withWriteAccessDo("Apply profile", function()
        flatfield_photo:applyDevelopSettings(main_settings)
    end)
    colorchecker_photo.catalog:withWriteAccessDo("Apply profile", function()
        colorchecker_photo:applyDevelopSettings(main_settings)
    end)
end


-- Copies the number to the clipboard and opens the export dialog for the colorchecker_photo
function startProfileExport(number, colorchecker_photo)
    CopyToClipboard(number)
    catalog:setSelectedPhotos(colorchecker_photo, {})
    colorchecker_photo.openExportDialog()
end


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

