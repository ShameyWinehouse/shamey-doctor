

RegisterNetEvent("rainbow_doctor:SetDuty")
AddEventHandler("rainbow_doctor:SetDuty", function(isOnDuty)
    local _source = source
    onDuty = isOnDuty
end)

RegisterNetEvent("rainbow_doctor:GetPaycheck")
AddEventHandler("rainbow_doctor:GetPaycheck",function()
	local _source = source
	local User = VorpCore.getUser(_source)
	local Character = User.getUsedCharacter
	
	for k, v in pairs (Config.Jobs) do
		for i, j in pairs (v.jobGrade) do
			if exports["rainbow-core"]:AbsolutelyHasJobAndGradeServer(_source, v.job, j.grade) then
				Character.addCurrency(0, j.paycheck)
				if Config.ShameyDebug then print("paycheck sent: ", _source) end
				TriggerClientEvent('vorp:Tip', _source, string.upper(v.job).." : Received your paycheck "..j.paycheck.."$", 10000)
			end
		end
	end
end)