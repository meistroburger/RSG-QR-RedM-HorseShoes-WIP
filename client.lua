function shoeHorse()
    -- Check player's job and inventory for necessary items
    if (PlayerData.job ~= "blacksmith") then
        return "You must be a blacksmith to shoe a horse."
    end
    if (PlayerData.inventory.horse_shoe < 4) then
        return "You do not have enough horse shoes in your inventory."
    end

    -- Get the coordinates of the blacksmith and the horse
    local blacksmithCoords = GetEntityCoords(PlayerPedId())
    local horseCoords = GetEntityCoords(GetHorse())

    -- Calculate the distance between the blacksmith and the horse
    local distance = Vdist(blacksmithCoords.x, blacksmithCoords.y, blacksmithCoords.z, horseCoords.x, horseCoords.y, horseCoords.z)

    -- Check if the blacksmith is close enough to the horse
    if distance > 3.0 then
        return "You must be close to the horse to shoe it."
    end

    -- Wait for the specified amount of time
    for i=1, 4 do
        Wait(shoeingTime)
    end

    -- Update number of shoes on horse
    horseShoes = horseShoes + 4
    PlayerData.inventory.horse_shoe = PlayerData.inventory.horse_shoe - 4
    TriggerServerEvent("updateInventory", PlayerData.inventory, horseShoes)
end

RegisterNetEvent("useHorseShoe")
AddEventHandler("useHorseShoe", function()
    shoeHorse()
end)
