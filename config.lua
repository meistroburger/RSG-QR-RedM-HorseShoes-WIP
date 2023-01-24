local OxMySQL = require "oxmysql"

-- Configuration for the horse shoeing mod

-- Database connection details
Config = {
    -- Time (in seconds) it takes to fit a shoe
    shoe_fitting_time = 15,

    -- Chance of losing a shoe at different speeds
    fast_speed_threshold = 60.0,
    fast_speed_shoe_loss_chance = 0.05,
    medium_speed_threshold = 40.0,
    medium_speed_shoe_loss_chance = 0.03,
    slow_speed_shoe_loss_chance = 0.01,

    -- Chance of losing a shoe when in a river
    river_shoe_loss_chance = 0.03
}

--connect to the database using OxMySQL
db = OxMySQL.open(Config.db_host, Config.db_username, Config.db_password, Config.db_database)
