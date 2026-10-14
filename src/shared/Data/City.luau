--!strict

local Config = require(script.Parent.Parent.Config)
local Types = require(script.Parent.Parent.Types)

local City: Types.CityLayout = {
	Ground = {
		Size = Config.CityGroundSize,
		Color = Color3.fromRGB(112, 124, 112),
	},
	Districts = {
		{
			Key = "MarketRow",
			Name = "Market Row",
			GroupKey = "Vendors",
			Color = Color3.fromRGB(220, 142, 64),
			AngleDeg = 54,
			Gate = {Key = "Prop.DistrictGate", Label = "Market Row", Offset = Vector2.new(-64.7, -88.9), Size = Vector3.new(16, 7, 1), Rotation = 36},
			NoticeBoard = {Key = "Prop.NoticeBoard", Label = "Market Row", Offset = Vector2.new(-55.8, -76.9), Size = Vector3.new(6, 5, 0.5)},
			Landmarks = {
				{Key = "Prop.Stall", Label = "Fish Stall", Offset = Vector2.new(-42, 28), Size = Vector3.new(16, 9, 12)},
				{Key = "Prop.Stall", Label = "Vegetable Stall", Offset = Vector2.new(-14, 28), Size = Vector3.new(16, 9, 12)},
				{Key = "Prop.Stall", Label = "Rice Stall", Offset = Vector2.new(14, 28), Size = Vector3.new(16, 9, 12)},
				{Key = "Prop.Stall", Label = "Dry Goods", Offset = Vector2.new(42, 28), Size = Vector3.new(16, 9, 12)},
				{Key = "Prop.DrainGrate", Label = "Market Drain", Offset = Vector2.new(0, -36), Size = Vector3.new(22, 1, 8), ProblemSite = "MarketDrain"},
			},
		},
		{
			Key = "Dockside",
			Name = "Dockside",
			GroupKey = "Workers",
			Color = Color3.fromRGB(65, 135, 198),
			AngleDeg = 126,
			Gate = {Key = "Prop.DistrictGate", Label = "Dockside", Offset = Vector2.new(64.7, -88.9), Size = Vector3.new(16, 7, 1), Rotation = -36},
			NoticeBoard = {Key = "Prop.NoticeBoard", Label = "Dockside", Offset = Vector2.new(55.8, -76.9), Size = Vector3.new(6, 5, 0.5)},
			Landmarks = {
				{Key = "Building.Warehouse", Label = "North Warehouse", Offset = Vector2.new(-30, 22), Size = Vector3.new(36, 16, 28), Color = Color3.fromRGB(132, 140, 142)},
				{Key = "Building.Warehouse", Label = "South Warehouse", Offset = Vector2.new(26, -24), Size = Vector3.new(36, 16, 28), Color = Color3.fromRGB(132, 140, 142)},
				{Key = "Building.Office", Label = "Dock Office", Offset = Vector2.new(34, 32), Size = Vector3.new(20, 12, 16)},
				{Key = "Prop.Crate", Label = "Crates", Offset = Vector2.new(-38, -24), Size = Vector3.new(8, 8, 8)},
				{Key = "Prop.Crate", Label = "Crates", Offset = Vector2.new(-26, -30), Size = Vector3.new(8, 8, 8)},
				{Key = "Prop.Crate", Label = "Crates", Offset = Vector2.new(-36, -38), Size = Vector3.new(8, 8, 8)},
			},
		},
		{
			Key = "Eastside",
			Name = "Eastside",
			GroupKey = "Students",
			Color = Color3.fromRGB(90, 166, 100),
			AngleDeg = 198,
			Gate = {Key = "Prop.DistrictGate", Label = "Eastside", Offset = Vector2.new(104.6, 34), Size = Vector3.new(16, 7, 1), Rotation = -108},
			NoticeBoard = {Key = "Prop.NoticeBoard", Label = "Eastside", Offset = Vector2.new(90.4, 29.4), Size = Vector3.new(6, 5, 0.5)},
			Landmarks = {
				{Key = "Building.School", Label = "Eastside School", Offset = Vector2.new(-12, 6), Size = Vector3.new(54, 26, 38), Color = Color3.fromRGB(224, 206, 150), ProblemSite = "EastsideSchool"},
				{Key = "Building.House", Label = "Eastside House 1", Offset = Vector2.new(44, -32), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Eastside House 2", Offset = Vector2.new(45, 30), Size = Vector3.new(20, 12, 18)},
			},
		},
		{
			Key = "Hillview",
			Name = "Hillview",
			GroupKey = "Families",
			Color = Color3.fromRGB(147, 104, 176),
			AngleDeg = 270,
			Gate = {Key = "Prop.DistrictGate", Label = "Hillview", Offset = Vector2.new(0, 110), Size = Vector3.new(16, 7, 1), Rotation = -180},
			NoticeBoard = {Key = "Prop.NoticeBoard", Label = "Hillview", Offset = Vector2.new(0, 95), Size = Vector3.new(6, 5, 0.5)},
			Landmarks = {
				{Key = "Building.House", Label = "Hillview House 1", Offset = Vector2.new(-42, -26), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Hillview House 2", Offset = Vector2.new(-14, 34), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Hillview House 3", Offset = Vector2.new(20, -30), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Hillview House 4", Offset = Vector2.new(42, 28), Size = Vector3.new(20, 12, 18)},
				{Key = "Prop.Footbridge", Label = "Hillview Footbridge", Offset = Vector2.new(0, 4), Size = Vector3.new(36, 4, 12), ProblemSite = "HillviewBridge"},
			},
		},
		{
			Key = "OldQuarter",
			Name = "Old Quarter",
			GroupKey = "Elders",
			Color = Color3.fromRGB(164, 132, 94),
			AngleDeg = 342,
			Gate = {Key = "Prop.DistrictGate", Label = "Old Quarter", Offset = Vector2.new(-104.6, 34), Size = Vector3.new(16, 7, 1), Rotation = 108},
			NoticeBoard = {Key = "Prop.NoticeBoard", Label = "Old Quarter", Offset = Vector2.new(-90.4, 29.4), Size = Vector3.new(6, 5, 0.5)},
			Landmarks = {
				{Key = "Building.Clinic", Label = "Old Quarter Clinic", Offset = Vector2.new(0, 12), Size = Vector3.new(34, 18, 26)},
				{Key = "Building.House", Label = "Old Quarter House 1", Offset = Vector2.new(-38, -32), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Old Quarter House 2", Offset = Vector2.new(0, -42), Size = Vector3.new(20, 12, 18)},
				{Key = "Building.House", Label = "Old Quarter House 3", Offset = Vector2.new(38, -32), Size = Vector3.new(20, 12, 18)},
			},
		},
	},
	Places = {
		{
			Key = "CouncilHall", Name = "Council Hall", Position = Vector2.new(0, 0), Size = Vector3.new(60, 40, 20),
			Color = Color3.fromRGB(190, 190, 190), Enterable = true, DoorSide = "Back", Rotation = 0, Radius = 36,
			Props = {
				{Key = "Prop.RosterBoard", Label = "Councilors", Offset = Vector2.new(-14, 2), Size = Vector3.new(12, 8, 1)},
				{Key = "Prop.TreasuryWindow", Label = "Treasury", Offset = Vector2.new(14, 2), Size = Vector3.new(12, 6, 1)},
			},
		},
		{
			Key = "RecordsOffice", Name = "Records Office", Position = Vector2.new(130, 60), Size = Vector3.new(40, 30, 14),
			Color = Color3.fromRGB(174, 178, 178), Enterable = true, DoorSide = "Front", Rotation = 65.2, Radius = 30,
			Props = {
				{Key = "Prop.PriceBoard", Label = "Price Board", Offset = Vector2.new(-10, 3), Size = Vector3.new(10, 6, 1)},
				{Key = "Prop.Shelf", Label = "Ledgers", Offset = Vector2.new(9, 4), Size = Vector3.new(5, 10, 3)},
				{Key = "Prop.Desk", Label = "Camera Film", Offset = Vector2.new(-8, -3), Size = Vector3.new(8, 3, 5)},
				{Key = "Prop.Desk", Label = "Audit Desk", Offset = Vector2.new(8, -3), Size = Vector3.new(8, 3, 5)},
			},
		},
	},
	Plaza = {
		Position = Vector2.new(0, 110),
		Radius = 45,
		Props = {
			{Key = "Prop.Podium", Label = "Podium", Offset = Vector2.new(0, 0), Size = Vector3.new(6, 4, 4)},
			{Key = "Prop.Bench", Label = "Bench", Offset = Vector2.new(-20, 8), Size = Vector3.new(12, 2, 3)},
			{Key = "Prop.Bench", Label = "Bench", Offset = Vector2.new(20, 8), Size = Vector3.new(12, 2, 3)},
		},
	},
	Yards = {
		{
			Key = "YardA", Name = "Contractor Yard A", Label = "Foreman Yard A", AngleDeg = 90, RadiusScale = 0.62, HalfExtent = 30,
			Props = {
				{Key = "Prop.Crate", Label = "Yard A Crates", Offset = Vector2.new(-10, -10), Size = Vector3.new(8, 8, 8)},
				{Key = "Prop.Crate", Label = "Yard A Crates", Offset = Vector2.new(10, -10), Size = Vector3.new(8, 8, 8)},
			},
		},
		{
			Key = "YardB", Name = "Contractor Yard B", Label = "Foreman Yard B", AngleDeg = 234, RadiusScale = 0.62, HalfExtent = 30,
			Props = {
				{Key = "Prop.Crate", Label = "Yard B Crates", Offset = Vector2.new(-10, -10), Size = Vector3.new(8, 8, 8)},
				{Key = "Prop.Crate", Label = "Yard B Crates", Offset = Vector2.new(10, -10), Size = Vector3.new(8, 8, 8)},
			},
		},
	},
	Paths = {
		{Key = "Path.Plaza", TargetKind = "Plaza", TargetKey = "Plaza"},
		{Key = "Path.RecordsOffice", TargetKind = "Place", TargetKey = "RecordsOffice"},
		{Key = "Path.MarketRow", TargetKind = "DistrictEdge", TargetKey = "MarketRow"},
		{Key = "Path.Dockside", TargetKind = "DistrictEdge", TargetKey = "Dockside"},
		{Key = "Path.Eastside", TargetKind = "DistrictEdge", TargetKey = "Eastside"},
		{Key = "Path.Hillview", TargetKind = "DistrictEdge", TargetKey = "Hillview"},
		{Key = "Path.OldQuarter", TargetKind = "DistrictEdge", TargetKey = "OldQuarter"},
	},
	Spawn = {
		Name = "FTM_Spawn",
		Offset = Vector2.new(0, 132),
	},
}

return City
