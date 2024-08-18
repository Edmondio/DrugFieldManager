local ox_inventory = exports.ox_inventory
local jsonFilePath = 'shared/data.json'
-- Variable de verrouillage du fichier json pour éviter les conflits de lecture/écriture
local lock = false



-- Attribution des objets au joueur après un vol de vitrine
RegisterNetEvent('edFarmDrugs:server:additem')
AddEventHandler('edFarmDrugs:server:additem', function(itemname, amount)
    local source = source
    local playerName = GetPlayerName(source)
    local identifier = GetPlayerIdentifier(source, 3)
    if ox_inventory:CanCarryItem(source, itemname, amount) then
        ox_inventory:AddItem(source, itemname, amount)
        if Logs.Types.farm.enabled then
            --local robType = type:gsub("^%l", string.upper)
            local logData = {
                link = Logs.Types.farm.webhook,
                title = '🌿 Recolte Champs',
                message = '**Player Name**: ' ..playerName..
                    '\n **Player ID**: '  ..tostring(source)..
                    '\n **Identifier**: ' ..tostring(identifier)..
                    '\n **Message**:  A recolter : ' ..amount..' '..itemname,
                color = 65280
            }
            DiscordLogs(logData)
        end
    else
        if ox_inventory:CanCarryItem(source, itemname, 1) then
            ox_inventory:AddItem(source, itemname, 1)
        else
            -- Informer le joueur que son inventaire est plein
            TriggerClientEvent('notification', source, 'Inventaire plein! Impossible de récupérer l\'objet.')
        end
    end
end)


RegisterNetEvent('edFarmDrugs:server:enterfarm')
AddEventHandler('edFarmDrugs:server:enterfarm', function(champsname)
    local source = source
    local playerName = GetPlayerName(source)
    local identifier = GetPlayerIdentifier(source, 3)
    if Logs.Types.enterfarm.enabled then
        --local robType = type:gsub("^%l", string.upper)
        local logData = {
            link = Logs.Types.enterfarm.webhook,
            title = '🌿 Entree Champs',
            message = '**Player Name**: ' ..playerName..
                '\n **Player ID**: '  ..tostring(source)..
                '\n **Identifier**: ' ..tostring(identifier)..
                '\n **Message**:  A entree dans le champs : ' ..champsname,
            color = 65280
        }
        DiscordLogs(logData)
    end
end)

local function loadFarmData()
    local file = LoadResourceFile(GetCurrentResourceName(), jsonFilePath)
    if file then
        --print("Fichier JSON chargé avec succès")
        return json.decode(file)
    else
        --print("Erreur lors du chargement du fichier JSON")
        return {}
    end
end


-- Fonction pour sauvegarder les données JSON avec gestion de verrouillage
local function saveFarmData(data)
    if lock then
        return
    end
    lock = true -- Acquérir le verrou
    local encodedData = json.encode(data)
    if encodedData then
        SaveResourceFile(GetCurrentResourceName(), jsonFilePath, encodedData, -1)
    else
        print("Error save JSON in ed_farmerdrugs")
    end
    lock = false -- Libérer le verrou
end

-- Fonction pour enregistrer l'heure actuelle et le nombre de récoltes pour un champ donné
local function updateFarmCount(farmName, count)
    local currentTime = os.time()
    local data = loadFarmData()
    if not data[farmName] then
        -- Trouvez la configuration pour ce champ
        local fieldConfig = nil
        for _, field in ipairs(Config.Fields) do
            if field.name == farmName then
                fieldConfig = field
                break
            end
        end
        if not fieldConfig then
            --print("Erreur: Champ " .. farmName .. " non trouvé dans la configuration")
            return
        end
        -- Initialiser les données pour le champ
        data[farmName] = {
            lastUpdate = currentTime,  -- Heure de la dernière mise à jour
            totalHarvests = 0,
            isFull = 0, -- Champ pas encore plein
            resetInterval = fieldConfig.resetInterval -- Durée avant la réinitialisation
        }
    end

    -- Mise à jour du nombre total de récoltes
    data[farmName].totalHarvests = data[farmName].totalHarvests + count
    -- Trouvez la configuration pour ce champ
    local fieldConfig = nil
    for _, field in ipairs(Config.Fields) do
        if field.name == farmName then
            fieldConfig = field
            break
        end
    end

    if fieldConfig and data[farmName].totalHarvests >= fieldConfig.maxItems then
        data[farmName].isFull = 1
        --ESX.ShowNotification('Le champ ' .. farmName .. ' est plein et nécessite une réinitialisation.')
    end

    -- Sauvegarder les données après mise à jour
    saveFarmData(data)
end


-- Callback pour vérifier s'il reste de la matière première à récolter dans un champ
ESX.RegisterServerCallback('edFarmDrugs:canHarvest', function(source, cb, farmName)
    local data = loadFarmData()
    -- Vérifiez que farmName n'est pas nil
    if farmName == nil then
        --print("Erreur: farmName est nil")
        cb(false)
        return
    end
    -- Trouver le champ correspondant dans Config.Fields
    local fieldConfig = nil
    for _, field in ipairs(Config.Fields) do
        if field.name == farmName then
            fieldConfig = field
            break
        end
    end
    -- Si le champ n'est pas trouvé dans la configuration, retournez une erreur
    if not fieldConfig then
        --print("Erreur: Champ " .. farmName .. " non trouvé dans la configuration")
        cb(false)
        return
    end
    -- Vérifiez si le champ existe dans les données et si la limite est atteinte
    if data[farmName] and data[farmName].totalHarvests >= fieldConfig.maxItems then
        cb(false) -- La récolte n'est pas possible car la limite est atteinte
    else
        cb(true) -- La récolte est possible
    end
end)



-- Mise à jour du nombre de récoltes pour un champ donné
RegisterNetEvent('edFarmDrugs:updateFarmCount')
AddEventHandler('edFarmDrugs:updateFarmCount', function(farmName, count)
    --print("Mise à jour du nombre de récoltes pour " .. farmName .. " avec " .. count)
    updateFarmCount(farmName, count)
end)


local function resetFarmData()
    local data = loadFarmData()
    local currentTime = os.time()

    print("Démarrage du processus de réinitialisation des champs.")

    for farmName, farmData in pairs(data) do
        -- Trouvez la configuration pour ce champ
        local fieldConfig = nil
        for _, field in ipairs(Config.Fields) do
            if field.name == farmName then
                fieldConfig = field
                break
            end
        end

        if not fieldConfig then
            --print("Erreur: Champ " .. farmName .. " non trouvé dans la configuration")
            return
        end

        -- Convertir le resetInterval en secondes
        local resetIntervalSeconds = fieldConfig.resetInterval * 60

        -- print("Vérification du champ " .. farmName .. ".")
        -- print("isFull: " .. tostring(farmData.isFull))
        -- print("Last Update: " .. os.date("%Y-%m-%d %H:%M:%S", farmData.lastUpdate))
        -- print("Current Time: " .. os.date("%Y-%m-%d %H:%M:%S", currentTime))
        -- print("Reset Interval: " .. fieldConfig.resetInterval .. " minutes (" .. resetIntervalSeconds .. " secondes)")

        -- Vérifiez si le champ est plein et si la période de réinitialisation est écoulée
        if farmData.isFull == 1 then
            -- print("Champ " .. farmName .. " est plein.")
            local elapsed = currentTime - farmData.lastUpdate
            -- print("Temps écoulé depuis la dernière mise à jour: " .. elapsed .. " secondes")

            if elapsed >= resetIntervalSeconds then
                -- Réinitialiser les données du champ
                data[farmName].totalHarvests = 0
                data[farmName].isFull = 0
                data[farmName].lastUpdate = currentTime
                -- print("Réinitialisation des récoltes pour le champ " .. farmName)
                if Logs.Types.enterfarm.enabled then
                    --local robType = type:gsub("^%l", string.upper)
                    local logData = {
                        link = Logs.Types.resetfarm.webhook,
                        title = '🌿 Reset Champs',
                        message = '**Champs**: ' ..farmName..
                            '\n**Message**:  Rénitialisation du champs de drogue : ' ..farmName,
                        color = 65280
                    }
                    DiscordLogs(logData)
                end
            else
                if Logs.Types.enterfarm.enabled then
                    --local robType = type:gsub("^%l", string.upper)
                    local remainingSeconds = resetIntervalSeconds - elapsed
                    local minutes = math.floor(remainingSeconds / 60)
                    local seconds = remainingSeconds % 60
                    local logData = {
                        link = Logs.Types.resetfarm.webhook,
                        title = '🌿 Reset Champs',
                        message = '**Champs**: ' ..farmName..
                            '\n**Champs vide :** ' ..farmName..
                            '\n**Prochain reset dans :** ' .. minutes .. ' minute' .. (minutes > 1 and 's' or '') .. ' et ' .. seconds .. ' seconde' .. (seconds > 1 and 's' or ''),
                        color = 65280
                    }
                    DiscordLogs(logData)
                end
                -- print("Le champ " .. farmName .. " ne peut pas être réinitialisé. Temps restant: " .. (resetIntervalSeconds - elapsed) .. " secondes")
            end
        else
            -- print("Champ " .. farmName .. " n'est pas plein.")
        end
    end

    saveFarmData(data)
end

-- Planification de la vérification de réinitialisation
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.ResetFarm * 60 * 1000) -- Vérifiez toutes les heures
        resetFarmData()
    end
end)



