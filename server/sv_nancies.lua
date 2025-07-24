

-- Trigger VORP's resurrection command
RegisterNetEvent("rainbow_doctor:CommandReviveMe")
AddEventHandler("rainbow_doctor:CommandReviveMe", function(playerCoords, currentTown)
    local _source = source

	if Config.ShameyDebug then print("rainbow_doctor:CommandReviveMe", _source, playerCoords, currentTown) end

    local cost = Config.NancyPrice

    local Character = VorpCore.getUser(_source).getUsedCharacter

    if Character.money < cost then
        TriggerClientEvent("rainbowMe:displayText", -1, _source, "Doesn't have enough money.")
        return
    end

    Character.removeCurrency(0, cost)
    TriggerClientEvent('vorp:resurrectPlayer', _source)

	TriggerEvent("rainbow_doctor:LogReviveMeOnDiscord", _source, cost, playerCoords, currentTown)
end)


RegisterNetEvent("rainbow_doctor:LogReviveMeOnDiscord")
AddEventHandler("rainbow_doctor:LogReviveMeOnDiscord", function(_source, cost, playerCoords, currentTown)
	if Config.ShameyDebug then print("rainbow_doctor:LogReviveMeOnDiscord", _source, cost, playerCoords, currentTown) end

	local downedCharacter = VorpCore.getUser(_source).getUsedCharacter
    local downedCharIdentifier = downedCharacter.charIdentifier
    local downedFullName = string.format("%s %s", downedCharacter.firstname, downedCharacter.lastname)
	
  	if not currentTown then
  	  currentTown = "Unknown"
  	end

	VorpCore.AddWebhook("A person used Nancy.", Config.Webhook, string.format(
        "**Downed Person:** %s (CharId %s)\n**Town:** %s\n**Cost:** $%.2f", 
        downedFullName, downedCharIdentifier, currentTown, cost))
end)