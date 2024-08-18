Config = {}

Config.ResetFarm = 5 -- minutes // Boucle de vérification de réinitialisation



Config.Fields = {
    {
        name = "Weed Field",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(2832.434, -1417.144, 10.336),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_weed_01",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT', --SCENARIO
        propCount = 10,
        items = {
            { name = "tete_lemon", amountMin = 1, amountMax = 3 }
        },
        maxItems = 285,
        resetInterval = 1080 -- minute
    },
    {
        name = "Champs Cheese",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(2215.54, 5566.79, 52.78),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_weed_05",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "tete_cheese", amountMin = 1, amountMax = 2 },
            { name = "feuille_weed", amountMin = 1, amountMax = 1 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    },
    {
        name = "Champs Lemon Haze",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(297.59, 4319.99, 46.33),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_weed_03",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "tete_lemon", amountMin = 1, amountMax = 2 },
            { name = "feuille_weed", amountMin = 1, amountMax = 1 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    },
    {
        name = "Champs Amnesia",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(247.26, 3590.56, 33.24),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_weed_04",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "tete_amnesia", amountMin = 1, amountMax = 2 },
            { name = "feuille_weed", amountMin = 1, amountMax = 1 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    },
    {
        name = "Champs Pavot",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(3710.61, 3089.42, 10.09),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_bzzz_gardenpack_poppy004",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "seve_pavot", amountMin = 1, amountMax = 2 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    },
    {
        name = "Champs Coke",
        itemsneed = 'secateur', -- Item pour la recolte
        coords = vector3(2680.35, 6304.25, 140.16),
        size = vector3(10.0, 10.0, 10.0),
        prop = "bzzz_plant_coca_a",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "feuille_cocaine", amountMin = 1, amountMax = 1 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    }, 
    {
        name = "Mine Lithium",
        itemsneed = 'pioche', -- Item pour la recolte
        coords = vector3(2952.74, 2789.14, 40.51),
        size = vector3(10.0, 10.0, 5.0),
        prop = "prop_rock_3_b",
        animrecolte = 'WORLD_HUMAN_GARDENER_PLANT',
        propCount = 10,
        items = {
            { name = "lithium", amountMin = 1, amountMax = 2 }
        },
        maxItems = 285,
        resetInterval = 1080 -- 1 minute
    }
    -- Ajouter d'autres champs ici
}




Config.DebugPolyZones = false -- Afficher les zones de polygone pour le débogage