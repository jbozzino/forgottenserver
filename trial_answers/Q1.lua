-- I assume this piece of code intends for the storage of the player to be deleted upon logout. I interpret -1 to be the value assigned to an empty (or unexisting) storage, and any other values could potentially have other meanings.

local function releaseStorage(player)
    -- Set the storage value to -1 
    player:setStorageValue(1000, -1)
end

function onLogout(player)
    -- Check if the storage value exists
    if player:getStorageValue(1000) != -1 then
        -- I deleted the 1000ms delay to call the function because I did not understand its functionality
        addEvent(releaseStorage, 0, player)
    end
    return true
end
