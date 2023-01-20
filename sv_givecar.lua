local QBCore = exports['qb-core']:GetCoreObject()



function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

QBCore.Commands.Add("givecar", "Give Vehicle to Players (Admin Only)", {{name="id", help="Player ID"}, {name="model", help="Vehicle Model, for example: t20"}, {name="plate", help="Custom Number Plate (Leave to assign random) , for example: ABC123"}}, false, function(source, args)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    local tPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local veh = args[2]
    local plate = args[3]
    if not plate or plate == "" then plate = GeneratePlate() end
    if veh and tPlayer then
        TriggerClientEvent('zeus:client:givecar', args[1], veh, plate)
	    TriggerClientEvent("QBCore:Notify", src, "You gave vehicle to "..tPlayer.PlayerData.charinfo.firstname.." "..tPlayer.PlayerData.charinfo.lastname.." Vehicle :"..veh.." With Plate : "..plate, "success", 8000)
        exports.oxmysql:insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            tPlayer.PlayerData.license,
            tPlayer.PlayerData.citizenid,
            veh,
            GetHashKey(veh),
            '{}',
            plate,
            0
        })
    else 
        TriggerClientEvent('QBCore:Notify', src, "Incorrect Format", "error")
    end
end, "god")
