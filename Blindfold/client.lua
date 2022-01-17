QBCore = nil 
local HaveBagOnHead = false

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

function ClosestPerson()
local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
local player = GetPlayerPed(-1)

  if closestPlayer == -1 or closestDistance > 2.0 then 
    QBCore.Functions.Notify("Yakınlarda oyuncu yok")
  else
    if not HaveBagOnHead then
      TriggerServerEvent('blindfold:sendclosest', GetPlayerServerId(closestPlayer))
      QBCore.Functions.Notify("Çuvalı taktın!")
      TriggerServerEvent('blindfold:closest')
    else
      QBCore.Functions.Notify("Bu kişinin kafasında zaten bir çanta var.")
    end
  end
end

RegisterNetEvent('blindfold:openpng')
AddEventHandler('blindfold:openpng', function()
    OpenBagMenu()
end)

RegisterNetEvent('blindfold:openpngNa')
AddEventHandler('blindfold:openpngNa', function(gracz)
    local playerPed = GetPlayerPed(-1)
    prop = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openGeneral'})
    HaveBagOnHead = true
    
    Citizen.Wait(30)
    QBCore.Functions.Notify("Kafana çuval geçirildi.")
end)    

AddEventHandler('playerSpawned', function()
DeleteEntity(prop)
SetEntityAsNoLongerNeeded(prop)
SendNUIMessage({type = 'closeAll'})
HaveBagOnHead = false
end)

RegisterNetEvent('blindfold:cikarmaske') --This event delete head bag from player head
AddEventHandler('blindfold:cikarmaske', function(gracz)
    
    QBCore.Functions.Notify("Çuval kafandan çıkartıldı")
    DeleteEntity(prop)
    SetEntityAsNoLongerNeeded(prop)
    SendNUIMessage({type = 'closeAll'})
    HaveBagOnHead = false
end)

function OpenBagMenu() --This function is menu function

    local elements = {
      {label = 'Çuvalı kafasına geçir', value = 'puton'},
      {label = 'Çuvalı kafasından çıkar', value = 'putoff'},
    }
  
    QBCore.UI.Menu.CloseAll()
  
    QBCore.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'headbagging',
      {
        title    = 'ÇUVAL',
        align    = 'top-left',
        elements = elements
        },
  
            function(data2, menu2)
  
  
              local player, distance = QBCore.Functions.GetClosestPlayer()
  
              if distance ~= -1 and distance <= 2.0 then
  
                if data2.current.value == 'puton' then
                    QBCore.Functions.Progressbar("unique_action_name", "Çuvalı geçiriyorsun..", 6000, false, false, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                  }, {
                    animDict = "random@shop_robbery",
                    anim = "robbery_action_b",
                    flags = 49,
                  }, {}, {}, function() -- Done
                    ClosestPerson()
                    
                  end, function() -- Cancel
                    QBCore.Functions.Notify("Çuvalı takmaktan vazgeçtin!")
                  end)
                end
  
                if data2.current.value == 'putoff' then
                    QBCore.Functions.Progressbar("unique_action_name", "Çuvalı çıkarıyorsun...", 3000, false, false, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                  }, {
                    animDict = "random@shop_robbery",
                    anim = "robbery_action_b",
                    flags = 49,
                  }, {}, {}, function() -- Done
                    TriggerServerEvent('blindfold:cikarttmaske')
                    QBCore.Functions.Notify("Çuvalı çıkarttın.")
                    
                  end, function() -- Cancel
                    QBCore.Functions.Notify("Çuvalı çıkarmaktan vazgeçtin!")
                  end)
                end
              else
                QBCore.Functions.Notify("Yakınlarda kişi yok.")
              end
            end,
      function(data2, menu2)
        menu2.close()
      end
    )
  
  end