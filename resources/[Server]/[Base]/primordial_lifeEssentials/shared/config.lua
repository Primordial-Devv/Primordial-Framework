ItemsUseable = {
    ["bread"] = {
        type = "food",
        prop = "prop_cs_burger_01",
        status = 200000,
        remove = true,
        anim = {dict = 'mp_player_inteat@burger', name = 'mp_player_int_eat_burger_fp', settings = {8.0, -8, -1, 49, 0, 0, 0, 0}}
    },

    ["water"] = {
        type = "drink",
        prop = "prop_ld_flow_bottle",
        status = 100000,
        remove = true,
        anim = {dict = 'mp_player_intdrink', name = 'loop_bottle', settings = {1.0, -1.0, 2000, 0, 1, true, true, true}}
    },

    ["beer"] = {
        type = "alcohol",
        prop = "prop_beer_pissh",
        status = 250000,
        remove = true,
        anim = {dict = 'mp_player_intdrink', name = 'loop_bottle', settings = {1.0, -1.0, 2000, 0, 1, true, true, true}}
    }
}