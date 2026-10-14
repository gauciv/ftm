--!strict

local Types = require(game:GetService("ReplicatedStorage").Shared.Types)

local Problems: {Types.ProblemSpec} = {
	{
		Key = "MarketDrain",
		Label = "Market Drain",
		DistrictKey = "MarketRow",
		SurfaceCycle = 0,
		StartValue = 8,
		RisePerCycle = 5,
	},
	{
		Key = "EastsideSchool",
		Label = "Eastside School Roof",
		DistrictKey = "Eastside",
		SurfaceCycle = 1,
		StartValue = 12,
		RisePerCycle = 6,
	},
	{
		Key = "HillviewBridge",
		Label = "Hillview Footbridge",
		DistrictKey = "Hillview",
		SurfaceCycle = 0,
		StartValue = 25,
		RisePerCycle = 8,
	},
}

return Problems
