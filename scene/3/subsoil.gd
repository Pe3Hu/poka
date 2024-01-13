extends MarginContainer


@onready var bg = $BG
@onready var stars = $Stars
@onready var cords = $Cords
@onready var blocks = $Blocks
@onready var trefoils = $Trefoils
@onready var constellations = $Constellations

var vastness = null
var center = null
var grids = {}
var fringe = {}
var axises = {}
var sides = {}
var cycle = []
var decors = {} 


func set_attributes(input_: Dictionary) -> void:
	vastness = input_.vastness
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.subsoil)
	center = custom_minimum_size * 0.5
	
	init_stars()
	init_cords()
	init_blocks()
	init_cycle()
	trefoils.position = center
	init_constellation()


func init_stars() -> void:
	var corners = {}
	corners.x = [0, Global.num.subsoil.col - 1]
	corners.y = [0, Global.num.subsoil.row - 1]
	var scenes = ["star", "cord"]
	var keys = ["axis", "side"]
	stars.position = center
	grids.star = {}
	
	for key in keys:
		var name_ = key
		
		if key == "axis":
			name_ += "e"
		 
		var dict = get(name_+"s")
		
		for scene in scenes:
			dict[scene] = {}
			
			for _key in Global.arr[key]:
				dict[scene][_key] = []
	
	for _i in Global.num.subsoil.row:
		for _j in Global.num.subsoil.col:
			var input = {}
			input.proprietor = self
			input.grid = Vector2(_j, _i)
			
			var star = Global.scene.star.instantiate()
			stars.add_child(star)
			star.set_attributes(input)
			
			for axis in Global.arr.axis:
				if corners[axis].has(int(input.grid[axis])):
					axises.star[axis].append(star)
					var index = corners[axis].find(int(input.grid[axis]))
					var side = Global.dict.side[axis][index]
					
					if !sides.star.has(side):
						sides.star[side] = []
						sides.cord[side] = []
					
					sides.star[side].append(star)
					star.sides.append(side)


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
	cord.update_axis()


func init_blocks() -> void:
	grids.block = {}
	blocks.position = center
	
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
	
	#for block in blocks.get_children():
	#	block.paint_based_on_index()


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


func init_cycle() -> void:
	var grid = Vector2()
	var star = grids.star[grid]
	var directions = []
	directions.append_array(Global.dict.neighbor.linear2)
	directions.pop_front()
	directions.append(Global.dict.neighbor.linear2.front())
	
	while star.grid != Vector2() or cycle.is_empty():
		var direction = directions.front()
		
		if !star.directions.has(direction):
			directions.pop_front()
			direction = directions.front()
		
		var cord = star.directions[direction]
		cycle.append(star)
		star = cord.get_another_star(star)
	
	decors.star = grids.star[Vector2(1, 1)]
	#decors.star.set_status("occupied")


func init_constellation() -> void:
	axises.index = 8
	design_shape()


func design_shape() -> void:
	reset()
	var description = Global.dict.fringe.index[axises.index]
	var func_name = "design_" + description.shape + "_shape"
	call(func_name)


func design_rhomb_shape() -> void:
	var _cords = []
	var axis = Global.arr.axis.pick_random()
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	
	var mirror = Global.dict.side.mirror[cord.side]
	var index = sides.cord[cord.side].find(cord)
	index = (index + 1) % sides.cord[cord.side].size()
	cord = sides.cord[mirror][index]
	_cords.append(cord)
	
	
	add_constellation(_cords)


func design_triangle_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	var axis = Global.arr.axis.pick_random()
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	
	var _stars = {}
	var star = null
	
	for _star in cord.stars:
		match _star.sides.size():
			1:
				_stars["edge"] = _star
			2:
				_stars["corner"] = _star
	
	for _cord in _stars["corner"].cords:
		if _cord != cord:
			_cords.append(_cord)
	
	if description.size.x > 1 or description.size.y > 1:
		for _cord in _stars["edge"].cords:
			if _cord != cord:
				_cords.append(_cord)
	
	add_constellation(_cords)


func design_rectangle_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	
	if description.size.x == 2:
		var axis = Global.arr.axis.pick_random()
		var cord = axises.cord[axis].pick_random()
		_cords.append(cord)
		
		var mirror = Global.dict.side.mirror[cord.side]
		var index = sides.cord[cord.side].find(cord)
		cord = sides.cord[mirror][index]
		_cords.append(cord)
	else:
		for axis in Global.arr.axis:
			_cords.append_array(axises.cord[axis])
	
	add_constellation(_cords)


func design_trapeze_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	var axis = Global.arr.axis.pick_random()
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	
	var mirror = Global.dict.side.mirror[cord.side]
	var index = sides.cord[cord.side].find(cord)
	cord = sides.cord[mirror][index]
	_cords.append(cord)
	
	var options = []
	
	for _cord in axises.cord[axis]:
		if !_cords.has(_cord):
			options.append(_cord)
	
	cord = options.pick_random()
	_cords.append(cord)
	
	if description.size.x == description.size.y:
		for _star in cord.stars:
			if _star.sides.size() == 2:
				for _cord in _star.cords:
					if _cord != cord and _cord.side != null:
						_cords.append(_cord)
						break
				
				break
	
	add_constellation(_cords)


func design_deadlock_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	var axis = null
	
	for _axis in Global.arr.axis:
		if description.size[_axis] > 0:
			axis = _axis
			break
	
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	
	if description.size.x + description.size.y == 2:
		for _star in cord.stars:
			if _star.sides.size() == 1:
				for _cord in _star.cords:
					if _cord != cord and _cord.side != null:
						_cords.append(_cord)
						break
				
				break
	
	add_constellation(_cords)


func add_constellation(cords_: Array) -> void:
	var input = {}
	input.proprietor = self
	input.cords = cords_
	input.shape = Global.dict.fringe.index[axises.index].shape
	
	var constellation = Global.scene.constellation.instantiate()
	constellations.add_child(constellation)
	constellation.set_attributes(input)


func shift_axises_index(shift_: int) -> void:
	var n = Global.dict.fringe.index.keys().size()
	axises.index = (axises.index + shift_ + n) % n
	design_shape()


func reset() -> void:
	if constellations.get_child_count() > 0:
		var constellation = constellations.get_child(0)
		constellations.remove_child(constellation)
		constellation.queue_free()
		
		while trefoils.get_child_count() > 0:
			var trefoil = trefoils.get_child(0)
			trefoils.remove_child(trefoil)
			trefoil.queue_free()
