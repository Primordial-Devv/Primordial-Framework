-- RegisterCommand('test', function(source, args, rawCommand)
--     local player = PlayerPedId()
--     local playerCoords = GetEntityCoords(player)
--     local playerHeading = GetEntityHeading(player)
--     local ptfxName = PL.Streaming.RequestNamedPtfxAsset('core')
--     UseParticleFxAssetNextCall(ptfxName)
--     SetParticleFxNonLoopedColour(1.0, 0.0, 0.0)
--     StartNetworkedParticleFxNonLoopedAtCoord('ent_dst_elec_fire_sp', playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, 0.0, 3.0, false, false, false)
--     RemoveNamedPtfxAsset(ptfxName)
-- end)



-- local testPoint = lib.points.new({
--     coords = vector3(1245.71, -1594.18, 53.15),
--     distance = 5.0,
-- })

-- function testPoint:nearby()
--     PL.Notification.ShowFloatingHelpNotification('You are near the test point!', self.coords)
-- end

RegisterCommand('input', function(source, args, rawCommand)
    local test = lib.inputDialog('Test Input', {
        {
            type = 'input',
            label = 'Test Input',
            description = 'Test Description',
            required = true,
        },
        {
            type = 'time',
            label = 'Test Time',
            description = 'Test Description',
            format = '24',
        },
        {
            type = 'checkbox',
            label = 'Test Checkbox',
            required = true,
        },
        {
            type = 'input',
            label = 'Test Input',
            description = 'Test Description',
            placeholder = 'Test Placeholder',
            password = true,
            required = true,
        },
        {
            type = 'checkbox',
            label = 'Test Checkbox',
            required = true,
        },
        {
            type = 'select',
            label = 'Test Select',
            options = {
                { label = 'Option 1', value = 'option1' },
                { label = 'Option 2', value = 'option2' },
                { label = 'Option 3', value = 'option3' },
            },
            required = true,
        },
        {
            type = 'multi-select',
            label = 'Test Multi-Select',
            options = {
                { label = 'Option 1', value = 'option1' },
                { label = 'Option 2', value = 'option2' },
                { label = 'Option 3', value = 'option3' },
            },
        },
        {
            type = 'number',
            label = 'Test Number',
            description = 'Test Description',
            default = 5,
        },
        {
            type = 'number',
            label = 'Test Number',
            description = 'Test Description',
            placeholder = '5',
        },
        {
            type = 'slider',
            label = 'Test Slider',
            default = 5,
            min = 0,
            max = 10,
            step = 1,
        },
    })
    if not test then
        return PL.Print.Log(3, false, 'Canceled')
    end
    PL.Print.Log(4, true, 'Test Checkbox: ', test)
end)

lib.registerMenu({
    id = 'test_id',
    title = 'Test Menu',
    options = {
        {
            label = 'Test Option',
            description = 'Test Description',
        },
        {
            label = 'Test Checkbox',
            checked = false,
        },
        {
            label = 'Test Scroll Button',
            values = {
                'test',
                'yop'
            }
        },
        {
            label = 'Test List',
            values = {
                'you',
                'can',
                'scroll',
                'this'
            }
        }
    },
    onSideScroll = function(selected, scrollIndex, args)
        PL.Print.Log(4, false, 'Scroll', selected, scrollIndex, args)
    end,
    onSelected = function(selected, secondary, args)
        if not secondary then
            PL.Print.Log(4, false, "Normal button")
        else
            if args.isCheck then
                PL.Print.Log(4, false, "Check button")
            end

            if args.isScroll then
                PL.Print.Log(4, false, "Scroll button")
            end
        end
        PL.Print.Log(4, true, selected, secondary, args)
    end,
    onCheck = function(selected, checked, args)
        PL.Print.Log(4, false, "Check: ", selected, checked, args)
    end,
}, function(selected, scrollIndex, args)
    PL.Print.Log(4, false, selected, scrollIndex, args)
end)
RegisterCommand('menulib', function(source, args, rawCommand)
    lib.showMenu('test_id')
end)

RegisterNetEvent('test:event:test', function(info)
    exports.ox_target:addBoxZone({
        coords = vec3(info.coords.x, info.coords.y, info.coords.z),
        size =vec3(1.0, 1.0, 1.5),
        debug = true,
        drawSprite = true,
        options = {
            {
                label = 'test',
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = info.id})
                end
            }
        }
    })
end)