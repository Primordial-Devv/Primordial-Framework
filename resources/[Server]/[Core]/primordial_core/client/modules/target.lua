local chairProps = {
    'ch_prop_casino_chair_01b',
    'sf_int3_chair_stool_44a34',
    'apa_mpa6_din_chair_01',
    'tr_int1_mod_barnachair_2',
    'v_med_fabricchair1',
    'v_corp_cd_chair',
    'v_corp_offchair',
    'sf_int1_comf_chair_3',
    'apa_mpa2_din_chair_00',
    'apa_mp_h_stn_chairarm_03',
    'v_res_m_armchair',
    'sf_int1_comf_chair_4',
    'hei_mpheist_yacht_frnyat_chair_h06',
    'v_50_chairsingle',
    'ba_prop_battle_club_chair_01',
    'ex_mp_h_stn_chairarm_03',
    'bkr_prop_clubhouse_chair_03',
    'v_res_mbchair',
    'v_ind_ss_chair3_cso',
    'prop_off_chair_04_s',
    'v_58_soloff_gchair2',
    'p_soloffchair_s',
    'ex_mp_h_off_chairstrip_01',
    'v_50_chairsingle12',
    'sum_mp_h_yacht_armchair_01',
    'v_corp_sidechair',
    'bkr_int_02_strip_chair',
    'v_corp_offchairfd',
    'apa_mp_h_stn_chairarm_23',
    'v_res_fh_barcchair',
    'v_corp_bk_chair2',
    'h4_prop_h4_weed_chair_01a',
    'bkr_int_02_chair_bar_table_01',
    'apa_mp_h_stn_chairstool_12',
    'ex_mp_h_stn_chairstrip_01',
    'apa_mpa2_din_chair_02',
    'tr_int1_mod_barnachair_005',
    'v_ind_ss_chair01',
    'prop_old_wood_chair',
    'v_corp_facebeanbagd',
    'xm_lab_chairarm_02',
}

--- Function to make the player sit on a chair
---@param entity number The entity to sit on
local function SitOnChair(entity)
    local ped = cache.ped
    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)

    local sitOffset = GetOffsetFromEntityInWorldCoords(entity, 0.0, -0.5, 0.0) -- Position légèrement en face de la chaise
    SetEntityCoords(ped, sitOffset.x, sitOffset.y, sitOffset.z, false, false, false, true)
    SetEntityHeading(ped, heading)

    local animDict = "anim@heists@prison_heistunfinished_biztarget_idle"
    local animName = "target_idle"

    PL.Streaming.RequestAnimDict(animDict, 1200)

    TaskPlayAnim(ped, animDict, animName, 8.0, -8, -1, 1, 0, false, false, false)
end

exports.ox_target:addModel(chairProps, {
    {
        name = 'primordial_core_target_sit_chair',
        label = 'Sit',
        icon = 'fa-solid fa-chair',
        distance = 4.0,
        onSelect = function(data)
            PL.Print.Log(4, false, 'Sit chair')
            local chair = data.entity
            if DoesEntityExist(chair) then
                SitOnChair(chair)
            else
                PL.Print.Log(4, false, "Chair not found")
            end
        end
    }
})

RegisterCommand('props', function()
    PL.Object.SpawnClientObject('ch_prop_casino_chair_01b', GetEntityCoords(cache.ped), function(object)
        FreezeEntityPosition(object, true)
        PL.Print.Log(4, false, object, 'Object spawned')
    end, true)
end, false)
