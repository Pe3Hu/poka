extends MarginContainer


@onready var bg = $BG
@onready var stars = $Stars
@onready var cords = $Cords
@onready var blocks = $Blocks
@onready var trefoils = $Trefoils

var vastness = null
var center = null
var grids = {}
var rings = {}


func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.sky)
	center = custom_minimum_size * 0.5
	
	init_stars()
	init_cords()
	init_blocks()
	trefoils.position = center


func init_stars() -> void:
	grids.star = {}
	stars.position = center
	
	for _i in Global.num.sky.row:
		for _j in Global.num.sky.col:
			var input = {}
			input.proprietor = self
			input.grid = Vector2(_j, _i)
	
			var star = Global.scene.star.instantiate()
			stars.add_child(star)
			star.set_attributes(input)


func init_cords() -> void:
	cords.position = center
	
	for star in stars.get_children():
		for direction in Global.dict.neighbor.linear2:
			var grid = star.grid + direction
			
			if grids.star.has(grid):
				var neighbor = grids.star[grid]
				
				if !star.neighbors.has(neighbor):
					add_cord(star, neighbor, direction)


func add_cord(first_: Polygon2D, second_: Polygon2D, direction_: Vector2) -> void:
	var input = {}
	input.proprietor = self
	input.stars = [first_, second_]
	
	var cord = Global.scene.cord.instantiate()
	cords.add_child(cord)
	cord.set_attributes(input)
	
	first_.neighbors[second_] = cord
	second_.neighbors[first_] = cord
	first_.cords[cord] = second_
	second_.cords[cord] = first_
	first_.directions[direction_] = cord
	var index = Global.dict.neighbor.linear2.find(direction_)
	index = (index + Global.num.star.quartet / 2) % Global.num.star.quartet
	second_.directions[Global.dict.neighbor.linear2[index]] = cord


func init_blocks() -> void:
	grids.block = {}
	blocks.position = center
	rings.block = {}
	rings.block[1] = []
	
	for star in stars.get_children():
		var _cords = []
		var grid = Vector2(star.grid)
		var _star = grids.star[grid]
		
		for direction in Global.dict.neighbor.linear2:
			if _star.directions.has(direction):
				var cord = _star.directions[direction]
				_cords.append(cord)
				grid += direction
				_star = grids.star[grid]
				#_star = cord.get_another_star(_star)
		
		if _cords.size() == Global.num.star.quartet:
			add_block(_cords)
	
	init_blocks_neighbors()
	
	for block in blocks.get_children():
		block.paint_based_on_index()


func add_block(_cords: Array) -> void:
	var input = {}
	input.proprietor = self
	input.cords = _cords
	
	var block = Global.scene.block.instantiate()
	blocks.add_child(block)
	block.set_attributes(input)
	
	#var ring = rings.block.keys().back()
	#var l = Global.num.star.quartet * (ring * 2 - 1)
	#rings.block[ring].append(block)
	#block.ring = ring
		#
	#if rings.block[ring].size() == l:
		#rings.block[ring + 1] = []


func init_blocks_neighbors() -> void:
	var n = 2
	
	for cord in cords.get_children():
		if cord.blocks.size() == n:
			for _i in n:
				var block = cord.blocks[_i]
				var neighbor = cord.blocks[(_i + 1) % n]
				block.neighbors[neighbor] = cord


func init_constellations() -> void:
	for _i in 3:
		var dimensions = 6
		add_constellation(dimensions)


func add_constellation(dimensions_: int) -> void:
	var input = {}
	input.proprietor = self
	input.blocks = []
	
	for _i in dimensions_:
		var options = fill_block_options(input.blocks)
		var block = Global.get_random_key(options)
		
		if block != null:
			input.blocks.append(block)
	
	var constellation = Global.scene.constellation.instantiate()
	vastness.constellations.add_child(constellation)
	constellation.set_attributes(input)


func fill_block_options(blocks_: Array) -> Dictionary:
	var options = {}
	var neighbors = []
	var weight = rings.block.keys().back() + 1
	
	if !blocks_.is_empty():
		for block in blocks_:
			for neighbor in block.neighbors:
				if neighbor.status == "freely" and !neighbors.has(neighbor) and !blocks_.has(neighbor):
					neighbors.append(neighbor)
	else:
		#neighbors.append_array(blocks.get_children())
		
		for ring in rings.block:
			for block in rings.block[ring]:
				if block.status == "freely":
					neighbors.append(block)
			
			if !neighbors.is_empty():
				break
	
	for neighbor in neighbors:
		options[neighbor] = weight - neighbor.ring
	#for ring in rings.block:
		#for block in rings.block[ring]:
			#if neighbors.has(block):
				#options.append(block)
	
	return options
