-- With 1 photo selected, this will apply the camera profile with that number to it
-- XXX.rw2
local LrTasks = import 'LrTasks'
local catalog = import "LrApplication".activeCatalog()
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'


LrTasks.startAsyncTask( function()
    local main_photo = catalog:getTargetPhotos()[1]
    local number = main_photo:getFormattedMetadata('fileName'):match("^(%d+)")
    main_photo.catalog:withWriteAccessDo("Apply profile", function()
        main_photo:applyDevelopSettings({CameraProfile = number})
    end)
    -- TODO: open it in the develop module?
end)

