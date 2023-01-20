local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('zeus:client:givecar', function(model, plate)
    QBCore.Functions.SpawnVehicle(model, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityAsMissionEntity(veh, true, true)
        local vehname = GetDisplayNameFromVehicleModel(hash):lower()
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end)
end)
