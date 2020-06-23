local msg = read()

local item_names = {"Stone","Grass Block","Dirt","Cobblestone","Sand","Oak Leaves","Spruce Leaves","Birch Leaves","Jungle Leaves","Glass","Shrub","Grass","Fern","Dead Bush","Stone Slab","Cobblestone Slab","Stone Bricks Slab","Stone Stairs","Ice","Snow Block","Netherrack","Stone Bricks","Mossy Stone Bricks","Cracked Stone Bricks","Chiseled Stone Bricks","Stone Brick Stairs","Mycelium","White Stone","RedPower Rubber Leaves","Marble","Basalt","Marble Brick","Basalt Cobblestone","Basalt Brick","IndustrialCraft Rubber Leaves","Glass Bottle","Low Covalence Dust","Sandstone Slab","Stone Pressure Plate","Stone Button","Gravel","Sandstone","Chiseled Sandstone","Cut Sandstone","Wooden Slab","Nether Brick","Nether Brick Fence","Stick","Flint","Flax Seeds","Lever","Nether Brick Stairs","Stone Sword","Bowl","Stone Sickle","Oak Planks","Spruce Planks","Birch Planks","Jungle Planks","Furnace","Cactus","Vines","Ink Sac","Rose Red","Cactus Green","Purple Dye","Cyan Dye","Light Gray Dye","Gray Dye","Pink Dye","Lime Dye","Dandelion Yellow","Light Blue Dye","Magenta Dye","Orange Dye","Indigo Dye","Medium Covalence Dust","Torch","Stone Shovel","Stone Hoe","Stone Pickaxe","Stone Axe","Cobweb","Wooden Stairs","Oak Fence","String","Fishing Rod","Ladder","Arrow","Dandelion","Rose","Wooden Pressure Plate","Lily Pad","Indigo Flower","RedPower Rubber Sapling","Wooden Shovel"}

for i = 1, #msg do
	local char = msg:sub(i, i)
	local ascii_code = string.byte(char)
	local item_name = item_names[ascii_code - 31]
	print(item_name)
end