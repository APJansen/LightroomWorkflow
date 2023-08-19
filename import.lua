-- With 1 photo selected, this will apply the camera profile with that number to it
-- XXX.rw2
local LrTasks = import 'LrTasks'
local catalog = import "LrApplication".activeCatalog()
local LrDialogs = import 'LrDialogs'
local LrApplicationView = import 'LrApplicationView'
local LrFileUtils = import 'LrFileUtils'


LrTasks.startAsyncTask( function()
    new_photos = AddPhotosFromFolder()
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
                table.insert(new_photos, photo)
            end
        end
    end
    return new_photos
end
