-- Database Configuration
local db = exports.oxmysql -- or exports.mysql-async, depending on what you use

-- Discord Webhook URL (Replace with yours)
local DISCORD_WEBHOOK = Config.DiscordWebHook

-- Function to generate a random 4-letter Permanent ID
local function generateRandomID()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local randomID = ""
    for i = 1, 4 do
        local randomIndex = math.random(1, #letters)
        randomID = randomID .. string.sub(letters, randomIndex, randomIndex)
    end
    return randomID
end

-- Function to send a message to Discord
local function sendToDiscord(name, id)
    local message = {
        username = "Player Registration",
        embeds = {{
            title = "📌 New Permanent ID Assigned",
            description = "**Player:** " .. name .. "\n**Permanent ID:** `" .. id .. "`",
            color = 16753920 -- Yellow
        }}
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) 
        if err ~= 200 then
            print("📌 Message sent to Discord")
        end
    end, "POST", json.encode(message), {["Content-Type"] = "application/json"})
end

-- Function to check if the Permanent ID already exists in the database
local function isIDUnique(randomID, callback)
    local query = "SELECT * FROM M_Id WHERE ID_Permanente = ?"
    db:query(query, { randomID }, function(result)
        callback(result == nil or #result == 0) -- true if unique
    end)
end

-- Function to get or create the player's Permanent ID
local function getOrCreatePlayerID(player)
    local steamName = GetPlayerName(player)
    local playerIdentifier = GetPlayerIdentifier(player, 0) -- Steam ID

    -- Check if the player already has an ID in the database
    local query = "SELECT ID_Permanente FROM M_Id WHERE identifier = ?"
    db:query(query, { playerIdentifier }, function(result)
        if result and #result > 0 then
            -- Player already has an ID, send it to the client
            local permanentID = result[1].ID_Permanente
            TriggerClientEvent('showPermanentID', player, permanentID)
        else
            -- Player doesn't have an ID, generate a new one
            local randomID = generateRandomID()
            isIDUnique(randomID, function(isUnique)
                if not isUnique then
                    getOrCreatePlayerID(player) -- Try again
                    return
                end

                -- Insert the new record into the database
                local insertQuery = "INSERT INTO M_Id (identifier, name, ID_Permanente) VALUES (?, ?, ?)"
                db:query(insertQuery, { playerIdentifier, steamName, randomID }, function(insertResult)
                    if insertResult then
                        print("✅ New player registered: " .. steamName .. " | Permanent ID: " .. randomID)

                        -- Send the ID to the client
                        TriggerClientEvent('showPermanentID', player, randomID)

                        -- 🔹 Send message to Discord only if it's a new ID
                        sendToDiscord(steamName, randomID)
                    else
                        print("❌ Error registering player in the database.")
                    end
                end)
            end)
        end
    end)
end

-- Event when a player connects
AddEventHandler('playerConnecting', function()
    local player = source
    getOrCreatePlayerID(player)
end)

-- Create the M_Id table if it doesn't exist
local function createTable()
    local query = [[
        CREATE TABLE IF NOT EXISTS M_Id (
            M_Id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(255) NOT NULL UNIQUE, 
            name VARCHAR(255) NOT NULL,
            ID_Permanente VARCHAR(4) NOT NULL UNIQUE
        )
    ]]
    db:query(query, {}, function(result)
        if result then
            print("✅ M_Id table created or already exists.")
        else
            print("❌ Error creating M_Id table.")
        end
    end)
end

-- Run table creation on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createTable()
    end
end)

-- Command to show the player's Permanent ID
RegisterCommand(Config.ShowIdCommand, function(source)
    local player = source
    local steamName = GetPlayerName(player)
    local playerIdentifier = GetPlayerIdentifier(player, 0)

    local query = "SELECT ID_Permanente FROM M_Id WHERE identifier = ?"
    exports.oxmysql:query(query, {playerIdentifier}, function(result)
        if result and #result > 0 then
            local permanentID = result[1].ID_Permanente
            TriggerClientEvent('showPermanentID', player, permanentID)

            -- Send native notification to the client
            TriggerClientEvent('notifyGTA', player, "Your Permanent ID is: ~y~·" .. permanentID)
        else
            TriggerClientEvent('notifyGTA', player, "❌ You don't have a Permanent ID registered.")
        end
    end)
end, false)
