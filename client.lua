local OxMySQL = require "oxmysql"
local Config = require "config"

-- Connect to the database using OxMySQL
local db = OxMySQL.open(Config.db_host, Config.db_username, Config.db_password, Config.db_database)

-- Create a table to store horse shoe information
db:query([[
    CREATE TABLE IF NOT EXISTS horse_shoes (
        horse_id INTEGER PRIMARY KEY,
        shoe_count INTEGER NOT NULL
    )
]])

-- Function to fit a shoe to a horse
function fitShoe(player, horse)
    local shoeCount = db:query("SELECT shoe_count FROM horse_shoes WHERE horse_id = ?", {horse:getHorseId()})[1].shoe_count
    if shoeCount >= 4 then
        player:sendChatMessage("This horse already has 4 shoes.")
        return
    end

    -- Check if player has the "horseshoe" item in their inventory
    if player:getInventory():hasItem("horseshoe", 1) then
        -- Remove the "horseshoe" item from the player's inventory
        player:getInventory():removeItem("horseshoe", 1)
        -- Wait for the shoe fitting time (configurable in config.lua)
        Wait(Config.shoe_fitting_time)
        -- Increase the horse's shoe count and save to the database
        shoeCount = shoeCount + 1
        db:query("UPDATE horse_shoes SET shoe_count = ? WHERE horse_id = ?", {shoeCount, horse:getHorseId()})
        -- Notify the player that they have fitted a shoe
        player:sendChatMessage("You have fitted a shoe to the horse's hoof. " .. (4 - shoeCount) .. " more shoes needed to complete.")
        -- Notify the blacksmith job role player
        player:sendChatMessage("You have shoed a horse hoof.")
    else
        player:sendChatMessage("You need a horseshoe to fit a shoe.")
    end
end

-- Function to calculate the chance of a horse losing a shoe
function calculateHorseShoeLossChance(player, horse)
    -- Get the player's speed
    local speed = player:getSpeed()
    -- Get the horse's shoe count
    local shoeCount = db:query("SELECT shoe_count FROM horse_shoes WHERE horse_id = ?", {horse:getHorseId()})[1].shoe_count
    -- Initialize the chance of losing a shoe to 0
    local chance = 0
    if player:getWaterLevel() > 0.3 then -- check if the player is in a river
    chance = Config.river_shoe_loss_chance
    else
    -- Calculate the chance of losing a shoe based on speed
    if speed > Config.fast_speed_threshold then
        chance = Config.fast_speed_shoe_loss_chance
    elseif speed > Config.medium_speed_threshold
        elseif speed > Config.medium_speed_threshold then
        chance = Config.medium_speed_shoe_loss_chance
    else
        chance = Config.slow_speed_shoe_loss_chance
    end
    end
    -- Check if the horse loses a shoe
    if math.random() < chance then
        -- Decrease the horse's shoe count and save to the database
        shoeCount = shoeCount - 1
        db:query("UPDATE horse_shoes SET shoe_count = ? WHERE horse_id = ?", {shoeCount, horse:getHorseId()})
        -- Notify the player that they have lost a shoe
        player:sendChatMessage("Your horse has lost a shoe. Visit a blacksmith.")
    end
end

-- Function to update the horse's speed based on the number of shoes
function updateHorseSpeed(horse)
    local shoeCount = db:query("SELECT shoe_count FROM horse_shoes WHERE horse_id = ?", {horse:getHorseId()})[1].shoe_count
    if shoeCount < 4 then
        horse:setSpeed(horse:getMaxSpeed() * 0.5)
    else
        horse:setSpeed(horse:getMaxSpeed())
    end
end

