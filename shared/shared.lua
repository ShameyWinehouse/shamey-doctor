
function getJobList()
	local jobList = {}
	for k,v in pairs(Config.Jobs) do
		jobList[#jobList+1] = v.job
	end
	return jobList
end