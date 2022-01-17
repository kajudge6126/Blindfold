QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('blindfold:closest')
AddEventHandler('blindfold:closest', function()
    local name = GetPlayerName(najblizszy)
    TriggerClientEvent('blindfold:openpngNa', najblizszy)
end)

RegisterServerEvent('blindfold:sendclosest')
AddEventHandler('blindfold:sendclosest', function(closestPlayer)
    najblizszy = closestPlayer
end)

RegisterServerEvent('blindfold:cikarttmaske')
AddEventHandler('blindfold:cikarttmaske', function()
    TriggerClientEvent('blindfold:cikarmaske', najblizszy)
end)

QBCore.Functions.CreateUseableItem('headbag', function(source)
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    TriggerClientEvent('blindfold:openpng', _source)
    TriggerEvent('blindfold:debugger', source)
end)