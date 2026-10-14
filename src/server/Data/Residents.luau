--!strict

type Teaching = {ProblemKey: string, Text: string}
type ResidentDefinition = {
	Key: string,
	Name: string,
	Role: string,
	DistrictKey: string,
	Anchor: string,
	Dx: number,
	Dz: number,
	Teaches: {Teaching}?,
	Greet: {string},
	Gossip: {string}?,
}

local Residents: {ResidentDefinition} = {
	{Key = "Nena", Name = "Aling Nena", Role = "Fish Vendor", DistrictKey = "MarketRow", Anchor = "Fish Stall", Dx = -3, Dz = 0, Teaches = {{ProblemKey = "MarketDrain", Text = "Market Drain floods ankle-deep when it rains."}}, Greet = {"Fresh fish, fresh complaints.", "Rain comes down. The water comes up.", "Buy something before the smell wins."}},
	{Key = "Tonyo", Name = "Mang Tonyo", Role = "Rice Seller", DistrictKey = "MarketRow", Anchor = "Rice Stall", Dx = 3, Dz = 0, Teaches = {{ProblemKey = "HillviewBridge", Text = "A cousin says the Hillview footbridge creaks."}}, Greet = {"Rice is steady. The bridge, less so.", "My cousin says the bridge makes a new noise each week.", "No credit today. The ledger has a memory."}},
	{Key = "Joy", Name = "Ate Joy", Role = "Dry Goods Vendor", DistrictKey = "MarketRow", Anchor = "Dry Goods", Dx = 0, Dz = 4, Greet = {"The stall fees rise faster than the roof leaks.", "Business is fine, if you ignore the fees.", "I sell dry goods. The market has other plans."}},
	{Key = "Boyet", Name = "Kuya Boyet", Role = "Tricycle Driver", DistrictKey = "MarketRow", Anchor = "NoticeBoard", Dx = -4, Dz = 4, Greet = {"Traffic moves. The council takes notes.", "I know every shortcut and none to a raise.", "The roads are fine if you own a boat."}, Gossip = {"Yard A always quotes high. Maybe the fence is expensive.", "I heard Yard A charges extra for the privilege of waiting."}},
	{Key = "Rico", Name = "Rico", Role = "Dock Worker", DistrictKey = "Dockside", Anchor = "Dock Office", Dx = -4, Dz = 0, Teaches = {{ProblemKey = "MarketDrain", Text = "His sister's stall floods when rain fills the Market Drain."}}, Greet = {"The tide is punctual. Payroll isn't.", "We move crates while the paperwork moves nowhere.", "At least the water knows where it is going."}},
	{Key = "Susan", Name = "Aling Susan", Role = "Net Mender", DistrictKey = "Dockside", Anchor = "DistrictCenter", Dx = 0, Dz = 7, Greet = {"The nets come back torn. So do the promises.", "Wages arrive late enough to qualify as history.", "I mend nets. Someone should mend the schedule."}},
	{Key = "Eddie", Name = "Mang Eddie", Role = "Crane Operator", DistrictKey = "Dockside", Anchor = "NoticeBoard", Dx = 4, Dz = 3, Teaches = {{ProblemKey = "EastsideSchool", Text = "His kid's classroom has buckets under the roof."}}, Greet = {"The crane lifts more than the budget does.", "My kid says the buckets have assigned seats.", "Steel is heavy. Excuses are lighter."}},
	{Key = "Sison", Name = "Mr. Sison", Role = "Teacher", DistrictKey = "Eastside", Anchor = "Eastside School", Dx = -5, Dz = 5, Teaches = {{ProblemKey = "EastsideSchool", Text = "The school roof leaks over three classrooms."}}, Greet = {"We teach arithmetic around the buckets.", "The children count drips when the lesson runs short.", "A dry classroom would be a useful teaching aid."}},
	{Key = "Alvarez", Name = "Mrs. Alvarez", Role = "Teacher", DistrictKey = "Eastside", Anchor = "Eastside School", Dx = 5, Dz = 5, Teaches = {{ProblemKey = "EastsideSchool", Text = "She has kept records of every school roof complaint."}}, Greet = {"I keep the records. They are complete.", "Please be precise. The dates matter.", "I have nothing to add without the documents."}},
	{Key = "Ligaya", Name = "Ligaya", Role = "Student", DistrictKey = "Eastside", Anchor = "NoticeBoard", Dx = 0, Dz = 5, Greet = {"The buckets have better attendance than some students.", "We moved math class to avoid the biggest drip.", "If it rains, bring a notebook and a mop."}},
	{Key = "Cora", Name = "Nanay Cora", Role = "Mother of Three", DistrictKey = "Hillview", Anchor = "Hillview Footbridge", Dx = -5, Dz = 2, Teaches = {{ProblemKey = "HillviewBridge", Text = "Her children cross the Hillview footbridge to school."}}, Greet = {"My children cross that bridge every morning.", "I count heads on one side, then the other.", "A short walk should not need a safety prayer."}},
	{Key = "Dado", Name = "Tatay Dado", Role = "Carpenter", DistrictKey = "Hillview", Anchor = "Hillview Footbridge", Dx = 5, Dz = 2, Teaches = {{ProblemKey = "HillviewBridge", Text = "The footbridge planks are cracked and its posts are rotting."}}, Greet = {"Those planks need replacing, not another speech.", "I can hear the posts complain from here.", "Wood tells the truth when you put weight on it."}},
	{Key = "Junjun", Name = "Jun-jun", Role = "Kid", DistrictKey = "Hillview", Anchor = "NoticeBoard", Dx = 0, Dz = -4, Greet = {"I want to jump off the bridge. Into the river, not the water below it.", "The bridge squeaks like it wants a day off.", "I can jump farther than the council can decide."}},
	{Key = "Andoy", Name = "Lolo Andoy", Role = "Retired Fisherman", DistrictKey = "OldQuarter", Anchor = "DistrictCenter", Dx = -6, Dz = -5, Greet = {"The mayor has been quiet lately.", "I have seen quieter tides, and they were warning signs.", "Old stories get longer when the answers get shorter."}},
	{Key = "Pacita", Name = "Lola Pacita", Role = "Pensioner", DistrictKey = "OldQuarter", Anchor = "Old Quarter Clinic", Dx = -5, Dz = 0, Greet = {"The clinic queue gets longer every week.", "I brought a chair. It has met everyone here.", "The waiting room is the city's most reliable service."}},
	{Key = "Mercado", Name = "Nurse Mercado", Role = "Clinic Nurse", DistrictKey = "OldQuarter", Anchor = "Old Quarter Clinic", Dx = 5, Dz = 0, Greet = {"We are short on supplies, not on patients.", "The shelves are tidy. The inventory is not.", "We make each bandage count twice."}},
}

return Residents
