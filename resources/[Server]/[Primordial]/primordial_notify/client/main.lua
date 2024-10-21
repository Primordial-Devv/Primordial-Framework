AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.PlayerData = sPlayer
    PlayerLoaded = true
end)

RegisterCommand('notify', function(source, args, rawCommand)
    PL.Notification({
        image = 'https://i.imgur.com/28pfEe6.png'
    })
end)

RegisterCommand('notify2', function(source, args, rawCommand)
    PL.Notification({
        message = 'CECI EST UN TEST DE NOTIFICATION AVEC IMAGE POUR VOIR SI CELA FONCTIONNE',
        image = 'https://cdn.discordapp.com/attachments/1246185100996116551/1291137882786107452/image.png?ex=66ffaa1b&is=66fe589b&hm=8b3cb7cc415a1d98fcd79555ee81d082a65f298ea9651a57f208e7b74230a2c9&'
    })
end)

RegisterCommand('notify3', function(source, args, rawCommand)
    PL.Notification({
        message = 'Hello World',
    })
end)

RegisterCommand('notify4', function(source, args, rawCommand)
    PL.Notification({
        message = 'Hello World',
        image = 'https://cdn.discordapp.com/attachments/1246185100996116551/1291137882786107452/image.png?ex=66ffaa1b&is=66fe589b&hm=8b3cb7cc415a1d98fcd79555ee81d082a65f298ea9651a57f208e7b74230a2c9&',
        color = '#ffffff'
    })
end)

RegisterCommand('notify5', function(source, args, rawCommand)
    PL.Notification({
        message = 'Hello World',
        image = 'https://cdn.discordapp.com/attachments/1246185100996116551/1291137882786107452/image.png?ex=66ffaa1b&is=66fe589b&hm=8b3cb7cc415a1d98fcd79555ee81d082a65f298ea9651a57f208e7b74230a2c9&',
        color = '#ffffff',
        duration = 10000
    })
end)