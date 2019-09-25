
RegisterITEMS( {
	name = "Scrap Ingot", -- name of the item
	weapon = nil, -- is it a weapon
	model = "models/gangwars/crafting/ingot.mdl", -- the model of it
	crafting = {
		["Scrap Metal"] = 10,
	}, -- what is the cost for crafting it
	price = {
		sell = 100, -- base value for selling it
		buy = 200, -- base value for buying it 
	},
	drop = 100, -- chance of it droping from a player
	use = nil,
})
