ESX = nil
local timer, Prisontimer, CanEscape = false, 0, true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler("esx:onPlayerSpawn", function()
    TriggerServerEvent("esx_extendedjail:suggestions")
end)

RegisterNetEvent("esx_extendedjail:suggestions")
AddEventHandler("esx_extendedjail:suggestions", function()
	TriggerEvent('chat:addSuggestion', '/jail', 'Jail player', {{ name="ID", help="Player ID"}, { name="Time", help="Time in minutes"}})
	TriggerEvent('chat:addSuggestion', '/pjail', 'Jail player to police own jail', {{ name="ID", help="Player ID"}, { name="Time", help="Time in minutes"}})
	TriggerEvent('chat:addSuggestion', '/unjail', 'Unjail player', {{ name="ID", help="Player ID"}})
end)

exports('OpenJailMenu', function(str)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_menu', {
		title = ('Time'),
	}, function (data2, menu)
		local JailTime = tonumber(data2.value)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if JailTime ~= nil then
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				TriggerServerEvent('esx_vankilapako:jailplayer_server', GetPlayerServerId(closestPlayer), JailTime, str)
				menu.close()
			end
		else
			ESX.ShowNotification('Virheellinen aika')
		end
	end, function (data2, menu)
		menu.close()
	end)
end)


RegisterNetEvent("esx_extendedjail:jailplayer")
AddEventHandler( "esx_extendedjail:jailplayer", function(_time, data)
	Prisontimer = (_time * 60)
	timer = true
	if data.jail == 'prison' then
		JailPlayer(data)
	elseif data.jail == 'pjail' then
		PJailPlayer(data)
	end
end)


RegisterNetEvent("esx_extendedjail:unjailplayer")
AddEventHandler( "esx_extendedjail:unjailplayer", function(JailType)
	UnJailPlayer(JailType)
end)

RegisterNetEvent("esx_extendedjail:StartAlarm")
AddEventHandler('esx_extendedjail:StartAlarm', function(data)

	if data == false then
		StopAlarm("PRISON_ALARMS", -1)
	elseif data == true then
		while not PrepareAlarm("PRISON_ALARMS") do
			Citizen.Wait(0)
		end
		StartAlarm("PRISON_ALARMS", 1)
	end
end)

RegisterNetEvent("esx_extendedjail:AlertCops")
AddEventHandler('esx_extendedjail:AlertCops', function()
	local coords = Config.PrisonBlip
	ESX.ShowAdvancedNotification(_U('alarm'), _U('alarm_place'), _U('alarm_reason'), 'CHAR_CALL911', 1)

	blipescape = AddBlipForCoord(coords)
    SetBlipSprite(blipescape, 161)
    SetBlipScale(blipescape, 1.0)
	SetBlipColour(blipescape, Config.BlipColor)
	
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_alarm'))
	EndTextCommandSetBlipName(blipescape)
end)

RegisterNetEvent('esx_extendedjail:killBlip')
AddEventHandler('esx_extendedjail:killBlip', function()
	RemoveBlip(blipescape)
end)

-- Timers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timer then
			Prisontimer = Prisontimer - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if timer and math.ceil(Prisontimer) > 1 then
			DrawText(_U('remaining_time', math.ceil(Prisontimer / 60)), 0.470, 0.970)
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if DistanceChecker then
			local playerped = PlayerPedId()
			local coords = GetEntityCoords(playerped)
			local distance = #(coords - Config.JailSpawnLocation)

			if distance > 150 then
				DoScreenFadeOut(500)
				Citizen.Wait(500)
				ESX.Game.Teleport(PlayerPedId(), Config.JailSpawnLocation)
				TriggerServerEvent('esx_extendedjail:webhook', GetPlayerServerId(PlayerId()))
				Citizen.Wait(1000)
				DoScreenFadeIn(500)
				ESX.ShowNotification(_U('outside_jail'))
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		Citizen.Wait(1)
		local letSleep = true
		local distance = #(playerPos - Config.EscapeAttempt)

		if distance < Config.DrawDistance then
			letSleep = false
			DrawMarker(23, Config.EscapeAttempt.x, Config.EscapeAttempt.y, Config.EscapeAttempt.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 2.0, Config.Color.r, Config.Color.g, Config.Color.b, 50, false, true, 2, false, false, false, false)

			if distance < 1.5 then
				ESX.ShowHelpNotification(_U('press_to_escape'))
				if IsControlJustReleased(0, 38) then

					ESX.TriggerServerCallback('esx_extendedjail:haveitem', function(cb)
						if cb == true then
							if CanEscape then
								CanEscape = false
								ESX.ShowNotification(_U('trying_to_computer'))
								Animation()

								Citizen.Wait(Config.TimeToAlarm)

								
								ESX.ShowNotification(_U('alarm_fire'))
								TriggerServerEvent('esx_extendedjail:alarm_server', true, true)

								if Config.Mhacking then
									TriggerEvent("mhacking:show")
									TriggerEvent("mhacking:start",7,35,hacksystem)
								else
									Citizen.Wait(Config.TimeToHack)
									PlayerList()
								end
							else
								ESX.ShowNotification(_U('already_started_error'))
							end
						else
							ESX.ShowNotification(_U('no_correct_item'))
						end
					end)
				end
			end
		end

		if letSleep then
			Citizen.Wait(1000)
		end
    end
end)

function hacksystem(success)
	if success then
		TriggerEvent('mhacking:hide')
		PlayerList()
	else
		TriggerEvent('mhacking:hide')
		ESX.ShowNotification(_U('failed_hacking_error'))
		TaskPlayAnim(PlayerPedId(), "anim@amb@warehouse@laptop@", "exit", 8.0, 8.0, 0.1, 0, 1, false, false, false)
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
		Citizen.Wait(40000)
		TriggerServerEvent('esx_extendedjail:alarm_remove')
		TriggerServerEvent('esx_extendedjail:alarm_server', false, false)
		CanEscape = true
	end
end


Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.PrisonBlip)

	SetBlipSprite(blip, Config.BlipSprite)
	SetBlipScale (blip, Config.BlipScale)
	SetBlipColour(blip, Config.BlipColor)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function DrawText(text, x, y)
	SetTextFont(4)
	SetTextScale(0.35, 0.35)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

function JailPlayer(data)

	if data.type == 'first' then
		SwitchOutPlayer(PlayerPedId(), 0, 2)
		Citizen.Wait(1500)

		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Wear.Male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Wear.Female)
			end
		end)

		Citizen.Wait(500)
		ESX.Game.Teleport(PlayerPedId(), Config.JailSpawnLocation)
		Citizen.Wait(1000)
		ESX.ShowNotification(_U('jailed', data.time))
		DistanceChecker = true
		SwitchInPlayer(PlayerPedId())
	elseif data.type == 'nofirst' then

		Citizen.Wait(8000)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Wear.Male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Wear.Female)
			end
		end)
		
		if data.distance > 110 then
			DoScreenFadeOut(500)
			Citizen.Wait(500)
			ESX.Game.Teleport(PlayerPedId(), Config.JailSpawnLocation)
			Citizen.Wait(1000)
			DoScreenFadeIn(500)
		end
		Citizen.Wait(5000)
		ESX.ShowNotification(_U('already_jailed'))
		DistanceChecker = true
	end
end

function PJailPlayer(data)
	if data.type == 'first' then
		ESX.ShowNotification(_U('pjailed', data.time))
	elseif data.type == 'nofirst' then
		Citizen.Wait(5000)
		ESX.ShowNotification(_U('already_pjailed'))
	end
end

-- Unjail Player
function UnJailPlayer(JailType)
	timer = false
	DistanceChecker = false
	if JailType == 'prison' then
		SwitchOutPlayer(PlayerPedId(), 0, 2)
		Citizen.Wait(1500)

		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)

		ESX.Game.Teleport(PlayerPedId(), Config.OutsideLocation)
		Citizen.Wait(1000)
		SwitchInPlayer(PlayerPedId())
	elseif JailType == 'pjail' then
		SwitchOutPlayer(PlayerPedId(), 0, 2)
		Citizen.Wait(1500)
		ESX.Game.Teleport(PlayerPedId(), Config.OutsideLocationPJail)
		Citizen.Wait(1000)
		SwitchInPlayer(PlayerPedId())
	end
end

function PlayerList()
	ESX.TriggerServerCallback('esx_extendedjail:players', function(players, cb)

		local elements = {}

		if cb then
			for i=1, #players, 1 do
				table.insert(elements, {
					label = players[i].name,
					playerid2 = players[i].pinfo
				})


				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_extendedjail', {
					title    = 'Vankilan Tietokanta', align    = 'bottom-right',
					elements = elements
				}, function(data, menu)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_extendedjail_confirm', {
						title    = 'Oletko varma?', align    = 'bottom-right',
						elements = {
							{label = ('no'),  value = 'no'},
							{label = ('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()
		
						if data2.current.value == 'yes' then
							TriggerServerEvent('esx_extendedjail:unjail_server', data.current.playerid2)
							ESX.UI.Menu.CloseAll()
							TaskPlayAnim(PlayerPedId(), "anim@amb@warehouse@laptop@", "exit", 8.0, 8.0, 0.1, 0, 1, false, false, false)
							Citizen.Wait(1000)
							ClearPedTasks(PlayerPedId())
							Citizen.Wait(Config.TimeAlarmLeft)
							TriggerServerEvent('esx_extendedjail:alarm_remove')
							TriggerServerEvent('esx_extendedjail:alarm_server', false, false)
							CanEscape = true
						end
		
					end, function(data2, menu2)
						menu2.close()
					end)
				end, function(data, menu)
					menu.close()
				end)
				
			end
		else
			ESX.ShowNotification(_U('no_players'))
			TaskPlayAnim(PlayerPedId(), "anim@amb@warehouse@laptop@", "exit", 8.0, 8.0, 0.1, 0, 1, false, false, false)
			Citizen.Wait(1000)
			ClearPedTasks(PlayerPedId())
			Citizen.Wait(40000)
			TriggerServerEvent('esx_extendedjail:alarm_remove')
			TriggerServerEvent('esx_extendedjail:alarm_server', false, false)
			CanEscape = true
		end
	end)
end


function Animation()
	local ped = PlayerPedId()
	local animDict = "anim@amb@warehouse@laptop@"

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		RequestAnimDict(animDict)
		Citizen.Wait(10)
	end
	
	ClearPedSecondaryTask(ped)
	SetEntityCoords(ped, 1831.39, 2603.2, 45.01, 1, 0, 0, 1)
	SetEntityHeading(ped, 3.7)
	TaskPlayAnim(ped, animDict, "enter", 8.0, 8.0, 0.1, 0, 1, false, false, false)
	Citizen.Wait(600)
	TaskPlayAnim(ped, animDict, "idle_a", 8.0, 8.0, -1, 1, 1, false, false, false)
end

RegisterCommand("testi5", function(source, args, raw)
	print(GetPlayerServerId(PlayerId()))
    TriggerServerEvent('esx_extendedjail:jailplayer_server', GetPlayerServerId(PlayerId()), 5, JailType)
end, false)