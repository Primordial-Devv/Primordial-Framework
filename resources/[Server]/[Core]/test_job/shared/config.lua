BlipEMSPublic = {
    Coords = vector3(-663.6245, 310.2391, 140.1481),
    Sprite = 61,
    Color = 75,
    Scale = 0.8,
    Name = "EMS"
}

BlipsEMSWork = {
    ["Boss"] = {
        Coords = vector3(-663.3332, 309.4033, 92.7443),
        Sprite = 61,
        Color = 3,
        Scale = 0.5,
        Name = "EMS | Patron"
    },
    ["Garage"] = {
        Coords = vector3(75.4098, -21.3151, 68.5308),
        Sprite = 61,
        Color = 3,
        Scale = 0.5,
        Name = "EMS | Garage"
    },
    ["farm 1"] = {
        Coords = vector3(75.4098, -21.3151, 68.5308),
        Sprite = 61,
        Color = 3,
        Scale = 0.5,
        Name = "EMS | Garage"
    },
}

SpawnNPCs = {
    ["Accueil"] = {
        Coords = vector4(-677.5476, 327.2818, 82.0832, 191.6102),
        Name = `S_M_Y_XMech_02_MP`,
        Scenario = "WORLD_HUMAN_AA_COFFEE",
    },
    ["Boss"] = {
        Coords = vector4(50.6357, -791.8729, 31.6795, 228.2265),
        Name = `S_M_Y_XMech_02_MP`,
        Scenario = "WORLD_HUMAN_AA_SMOKE",
        Message = "Gestion Entreprise",
    }
}

Ascenseur1Target = {
    {
        TargetCoords = vector3(-668.120, 328.100, 78.600),           -- Etage -1
        TpCoords = vector3(-667.1996, 326.5865, 78.1240)
    },
    {
        TargetCoords = vector3(-668.0370, 327.8091, 78.1240),           -- Etage 0
        TpCoords = vector3(-667.2039, 326.5965, 83.0822)
    },
    {
        TargetCoords = vector3(-668.0370, 327.8091, 78.1240),           -- Etage 1
        TpCoords = vector3(-667.2079, 326.6056, 88.0145)
    },
    {
        TargetCoords = vector3(-668.0370, 327.8091, 78.1240),           -- Etage 2
        TpCoords = vector3(-667.2116, 326.6145, 92.7414)
    },
    {
        TargetCoords = vector3(-668.0370, 327.8091, 78.1240),           -- Etage 3
        TpCoords = vector3(-667.2102, 326.5875, 140.1225)
    },
}



UseTarget = "ox_target"   -- ox_target or qb_target or false










--███████╗░█████╗░██████╗░███╗░░░███╗██╗███╗░░██╗░██████╗░
--██╔════╝██╔══██╗██╔══██╗████╗░████║██║████╗░██║██╔════╝░
--█████╗░░███████║██████╔╝██╔████╔██║██║██╔██╗██║██║░░██╗░
--██╔══╝░░██╔══██║██╔══██╗██║╚██╔╝██║██║██║╚████║██║░░╚██╗
--██║░░░░░██║░░██║██║░░██║██║░╚═╝░██║██║██║░╚███║╚██████╔╝
--╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░



FarmPharmacy = {
    ["Coton"] = {
        TargetCoord = vector3(-659.2205, 314.2754, 82.3258),
        ItemToFarm = "coton";
        MaxItemToFarm = 30,
        TimeToGiveItem = 1000
    },
    ["Alcool"] = {
        TargetCoord = vector3(-662.2369, 315.6130, 82.0),
        ItemToFarm = "alcool";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
    ["Sparadrap"] = {
        TargetCoord = vector3(-658.7797, 317.0912, 82.7321),
        ItemToFarm = "sparadrap";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
    ["Plastique"] = {
        TargetCoord = vector3(-658.5352, 319.8864, 82.7321),
        ItemToFarm = "plastic";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
    ["MedicalMask"] = {
        TargetCoord = vector3(-661.9591, 318.4845, 82.0),
        ItemToFarm = "medi_mask";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
    ["Oxygene"] = {
        TargetCoord = vector3(-661.7, 321.4660, 82.0),
        ItemToFarm = "oxygen";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
    ["Defibrilateur"] = {
        TargetCoord = vector3(-658.3008, 322.5657, 82.7321),
        ItemToFarm = "defib";
        MaxItemToFarm = 10,
        TimeToGiveItem = 1000
    },
}