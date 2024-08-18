local currentItems = {}
local activeZones = {}
local createdProps = {}

-- Pour l'animation de mine
-- anim = {dict = 'melee@hatchet@streamed_core', clip = 'plyr_rear_takedown_b'},
-- prop = {bone = 28422, model = 'prop_tool_pickaxe', pos = vec3(0.09, -0.05, -0.02), rot = vec3(-78.0, 13.0, 28.0)}


-- Charger les configurations des champs
for _, field in ipairs(Config.Fields) do
    currentItems[field.name] = 0

    -- Stocker l'état des props créés
    local propsCreated = false

    -- Créer la zone plus petite où les props seront créés
    local propZone = lib.zones.box({
        coords = field.coords,
        size = field.size,
        rotation = 0,
        debug = Config.DebugPolyZones,
        onEnter = function()
            -- Rien ici, car la création de props sera déclenchée par la triggerZone
        end,
    })

    -- Créer la zone plus grande qui déclenchera la création des props dans la propZone
    local triggerZone = lib.zones.box({
        coords = field.coords,
        size = {
            x = field.size.x * 20, -- Ajustez la taille selon vos besoins
            y = field.size.y * 20, -- Ajustez la taille selon vos besoins
            z = field.size.z * 10, -- Ajustez la taille selon vos besoins
        },
        rotation = 0,
        debug = Config.DebugPolyZones,
        onEnter = function()
            -- LOGS DISCORD POUR SAVOIR QUI RENTRE DANS LA ZONE
            TriggerServerEvent('edFarmDrugs:server:enterfarm', field.name)
            
            -- Créer des props dans la petite zone si ce n'est pas déjà fait
            if not propsCreated then
                for i = 1, field.propCount do
                    local propCoords = GetRandomCoordOnGroundInZone(propZone) -- Utilise la petite zone pour obtenir les coordonnées
                    local prop = CreateObject(field.prop, propCoords.x, propCoords.y, propCoords.z, false, true, false)
                    -- Rendre le prop invincible
                    FreezeEntityPosition(prop, true)
                    SetEntityInvincible(prop, true)
                    SetEntityProofs(prop, false, false, false, false, true, true, true, true)

                    -- Ajouter le prop à la liste des props créés
                    table.insert(createdProps, prop)

                    -- Configurer l'interaction du prop
                    SetupPropInteraction(prop, field)
                end
                propsCreated = true -- Marquer les props comme créés
            end
        end,
    })

    activeZones[field.name] = { zone = triggerZone, propZone = propZone }
end

-- -- Charger les configurations des champs
-- for _, field in ipairs(Config.Fields) do
--     currentItems[field.name] = 0

--     -- Stocker l'état des props créés
--     local propsCreated = false

--     -- Définir la zone pour chaque champ
--     local zone = lib.zones.box({
--         coords = field.coords,
--         size = field.size,
--         rotation = 0,
--         debug = Config.DebugPolyZones,
--         onEnter = function()
--             -- Créer des props dans la zone si ce n'est pas déjà fait
--             -- LOGS DISCORD POUR SAVOIR QUI RENTRE DANS LA ZONE
--             TriggerServerEvent('edFarmDrugs:server:enterfarm', field.name)
--             if not propsCreated then
--                 for i = 1, field.propCount do
--                     local propCoords = GetRandomCoordOnGroundInZone(field)
--                     local prop = CreateObject(field.prop, propCoords.x, propCoords.y, propCoords.z, false, true, false)
--                     --Rendre le prop invincible
--                     FreezeEntityPosition(prop, true)
--                     SetEntityInvincible(prop, true)
--                     SetEntityProofs(prop, false, false, false, false, true, true, true, true)

--                     -- Ajouter le prop à la liste des props créés
--                     table.insert(createdProps, prop)

--                     -- Configurer l'interaction du prop
--                     SetupPropInteraction(prop, field)
--                 end
--                 propsCreated = true -- Marquer les props comme créés
--             end
--         end,
--     })

--     activeZones[field.name] = { zone = zone }
-- end

-- Définir une fonction pour configurer l'interaction du prop
function SetupPropInteraction(prop, field)
    exports.ox_target:addLocalEntity(prop, {
        {
            name = 'ox:harvest_' .. field.name,
            label = 'Récolter',
            icon = 'fa-solid fa-leaf',
            items = field.itemsneed,
            distance = 1,
            onSelect = function()
                local farmname = tostring(field.name)
                ESX.TriggerServerCallback('edFarmDrugs:canHarvest', function(canHarvest)
                    if canHarvest then
                        if lib.progressCircle({
                            duration = 10000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true,
                                sprint = true,
                            },
                            anim = {
                                scenario = field.animrecolte
                            }
                        }) then
                            -- Parcourir les items à récolter configurés dans le champ
                            for _, item in ipairs(field.items) do
                                local amount = math.random(item.amountMin, item.amountMax)
                                -- Ajouter l'item à l'inventaire du joueur
                                TriggerServerEvent('edFarmDrugs:server:additem', item.name, amount)
                                -- Mettre à jour le nombre total de récoltes dans le fichier JSON
                                TriggerServerEvent('edFarmDrugs:updateFarmCount', farmname, amount)
                            end
                        else
                            ClearPedTasksImmediately(PlayerPedId())
                        end
                    else
                        -- Le joueur ne peut plus récolter, limite atteinte
                        ESX.ShowNotification('Plus rien à recolter ici.')
                    end
                end, farmname)
            end
        }
    })
end


-- Fonction pour obtenir une coordonnée aléatoire dans la zone avec ajustement sur le sol
function GetRandomCoordOnGroundInZone(field)
    local x = field.coords.x + math.random() * field.size.x - (field.size.x / 2)
    local y = field.coords.y + math.random() * field.size.y - (field.size.y / 2)
    local groundZ
    local foundGround, z = GetGroundZFor_3dCoord(x, y, field.coords.z + 100.0, false) -- Ajuster la hauteur de recherche

    if foundGround then
        groundZ = z
    else
        groundZ = field.coords.z -- Fallback au cas où le sol n'est pas trouvé
    end
    return vector3(x, y, groundZ)
end

-- Événement déclenché lors de l'arrêt de la ressource
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Supprimer toutes les zones
        for _, zoneData in pairs(activeZones) do
            if zoneData.zone then
                zoneData.zone:remove()
            end
        end
        -- Supprimer tous les props créés
        for _, prop in ipairs(createdProps) do
            if DoesEntityExist(prop) then
                DeleteObject(prop)
            end
        end
        -- Réinitialiser les tables
        activeZones = {}
        createdProps = {}
    end
end)


