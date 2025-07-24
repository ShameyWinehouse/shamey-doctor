
VorpInv = exports.vorp_inventory:vorp_inventoryApi()


Citizen.CreateThread(function ()

    Citizen.Wait(3000)

    -- Register the crafting locations
    for key, location in pairs(Config.CraftingLocations) do
        if Config.ShameyDebug then print("registering location: ", location) end
        TriggerEvent("vorp:AddCraftLocation", location)
    end

    -- Register the crafting recipes
    for k, recipe in pairs(Config.CraftingRecipes) do
		if Config.ShameyDebug then print("registering recipe: ", recipe) end
        TriggerEvent("vorp:AddRecipes", recipe)
    end
end)


-- Register the usable items
Citizen.CreateThread(function()
	Wait(500)

    for k, usableItem in pairs(Config.UseItems) do
        
        -- Bandage
        if usableItem.Type == "bandage" then

            local itemName = usableItem.Name
            VorpInv.RegisterUsableItem(itemName, function(data)
                if Config.ShameyDebug then print("bandage used", itemName, data.item) end
                TriggerClientEvent("rainbow_doctor:UseBandage", data.source, data.item)
                -- TriggerEvent("vorpCore:subItem", data.source, itemName, 1)
                VorpInv.CloseInv(data.source)
            end)

        -- Medicine
        elseif usableItem.Type == "medicine" then

            local itemName = usableItem.Name
            VorpInv.RegisterUsableItem(itemName, function(data)
                if Config.ShameyDebug then print("medicine used", itemName, data.item) end
                TriggerClientEvent("rainbow_doctor:UseMedicine", data.source, data.item)
                -- TriggerEvent("vorpCore:subItem", data.source, itemName, 1)
                VorpInv.CloseInv(data.source)
            end)

        -- Other
        elseif usableItem.Type == "other" then

            local itemName = usableItem.Name
            VorpInv.RegisterUsableItem(itemName, function(data)
                if Config.ShameyDebug then print("other used", itemName, data.item) end
                TriggerClientEvent("rainbow_doctor:UseOther", data.source, data.item)
                -- TriggerEvent("vorpCore:subItem", data.source, itemName, 1)
                VorpInv.CloseInv(data.source)
            end)

        -- Cigarette
        elseif usableItem.Type == "cigarette" then

            local itemName = usableItem.Name
            VorpInv.RegisterUsableItem(itemName, function(data)
                if Config.ShameyDebug then print("cigarette used", itemName, data.item) end
                TriggerClientEvent("rainbow_doctor:UseCigarette", data.source, data.item)
                VorpInv.CloseInv(data.source)
            end)

        end

    end

    -- Healing Balm
	VorpInv.RegisterUsableItem(Config.HealingBalm.ItemName, function(data)
		if Config.ShameyDebug then print("healing balm used") end
		TriggerClientEvent("rainbow_doctor:UseBalmHealing", data.source, data.item)
		-- TriggerEvent("vorpCore:subItem", data.source, Config.HealingBalm.ItemName, 1)
	end)

end)


RegisterNetEvent("rainbow_doctor:UsedItem")
AddEventHandler("rainbow_doctor:UsedItem", function(itemName)
    local _source = source

    if Config.ShameyDebug then print("rainbow_doctor:UsedItem", itemName) end

    TriggerEvent("vorpCore:subItem", _source, itemName, 1)
end)