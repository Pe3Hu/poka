extends MarginContainer


#region vars
@onready var bg = $BG
@onready var stars = $Stars
@onready var cords = $Cords
@onready var blocks = $Blocks
@onready var trefoils = $Trefoils
@onready var fusions = $Fusions

var soil = null
var sky = null
var oasis = null
var center = null
var core = null
var grids = {}
var fringe = {}
var axises = {}
var sides = {}
var cycle = []
var chain = []
var turns = {}
var flips = {}
var request = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	soil = input_.soil
	
	init_basic_setting()


func init_basic_setting() -> void:
	sky = soil.vastness.horizon.sky
	oasis = soil.vastness.oasis
	custom_minimum_size = Vector2(Global.vec.size.subsoil)
	center = custom_minimum_size * 0.5
	
	init_stars()
	init_cords()
	init_cycle()
	init_turns()
	init_flips()
	trefoils.position = center
	init_fusion()


func init_stars() -> void:
	var corners = {}
	corners.x = [0, Global.num.subsoil.col - 1]
	corners.y = [0, Global.num.subsoil.row - 1]
	var scenes = ["star", "cord"]
	var keys = ["axis", "side", "turn"]
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
				
				if key == "turn":
					dict[scene][_key] = {}
	
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
#endregion


#region rotation connections 
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
		chain.append(cord)
		cycle.append(star)
		star = cord.get_another_star(star)
	
	core = grids.star[Vector2(1, 1)]
	#core.set_status("occupied")


func init_turns() -> void:
	var shifts = {}
	shifts.clockwise = 2
	shifts.counterclockwise = -2
	
	for _i in cycle.size():
		var star = cycle[_i]
		
		for turn in shifts:
			var shift = shifts[turn]
			var _j = (_i + shift + cycle.size()) % cycle.size()
			turns.star[turn][star] = cycle[_j]
	
	for turn in Global.arr.turn:
		turns.star[turn][core] = core


func init_flips() -> void:
	flips.star = {}
	var shift = 6
	var index = stars.get_children().find(core)
	
	for _i in stars.get_child_count():
		var star = stars.get_child(_i)
		var gap = index - _i
		var _j = index - gap + shift
		
		if abs(gap) > 1:
			if sign(gap) < 0:
				_j = _i + (index - shift * 1.5 - 1)
		else:
			_j = _i
		
		flips.star[star] = stars.get_child(_j)
#endregion


func init_fusion() -> void:
	axises.index = 10
	design_shape()
	oasis.choose_best()


#region of design shape
func design_shape() -> void:
	reset()
	
	if !sky.slots.priority.is_empty():
		design_shape_based_on_priority()
		
	var description = Global.dict.fringe.index[axises.index]
	var func_name = "design_" + description.shape + "_shape"
	call(func_name)
	
	if !sky.slots.priority.is_empty():
		pass
	
	oasis.init_mirages()


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
	
	add_fusion(_cords)


func design_triangle_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	var axis = Global.arr.axis.pick_random()
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	var _stars = {}
	
	for star in cord.stars:
		match star.sides.size():
			1:
				_stars["edge"] = [star]
			2:
				_stars["corner"] = star
	
	for _cord in _stars["corner"].cords:
		if _cord != cord:
			_cords.append(_cord)
			
			for star in _cord.stars:
				if star.sides.size() == 1:
					_stars["edge"].append(star)
	
	var n = description.primary + description.secondary - 2
	
	for _i in n:
		var star = _stars["edge"].pick_random()
		_stars["edge"].erase(star)
		
		for _cord in star.cords:
			if _cord != cord:
				_cords.append(_cord)
	
	add_fusion(_cords)


func design_rectangle_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	
	if description.primary == 2:
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
	
	add_fusion(_cords)


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
	
	if description.primary == description.secondary:
		for _star in cord.stars:
			if _star.sides.size() == 2:
				for _cord in _star.cords:
					if _cord != cord and _cord.side != null:
						_cords.append(_cord)
						break
				
				break
	
	add_fusion(_cords)


func design_deadlock_shape() -> void:
	var description = Global.dict.fringe.index[axises.index]
	var _cords = []
	var axis = Global.arr.axis.pick_random()
	var cord = axises.cord[axis].pick_random()
	_cords.append(cord)
	
	if description.primary == 0 and description.secondary == 2:
		
		for _star in cord.stars:
			if _star.sides.size() == 1:
				for _cord in _star.cords:
					if _cord != cord and _cord.side != null:
						_cords.append(_cord)
						break
				
				break
	else:
		var n = description.primary + description.secondary - 1
		
		var options = []
		var index = chain.find(cord)
		
		for _i in chain.size():
			if _i % 2 == index % 2 and index != _i:
				options.append(chain[_i])
		
		
		for _i in n:
			var _cord = options.pick_random()
			_cords.append(_cord)
			options.erase(_cord)
	
	add_fusion(_cords)


func cords_repetition_check(mirage_: MarginContainer) -> bool:
	var mirages = [self, mirage_]
	
	for mirage in mirages:
		mirage.fill_cords()
	
	for _i in cords.keys().size():
		var cord = cords.keys()[_i]
		
		if !mirage_.cords.has(cord):
			return false
		
		if cords[cord].vocation != mirage_.cords[cord].vocation:
			return false
	
	return true


func add_fusion(cords_: Array) -> void:
	var input = {}
	input.proprietor = self
	input.cords = cords_
	input.shape = Global.dict.fringe.index[axises.index].shape
	
	var fusion = Global.scene.fusion.instantiate()
	fusions.add_child(fusion)
	fusion.set_attributes(input)


func get_fusion() -> Variant:
	if fusions.get_child_count() > 0:
		var fusion = fusions.get_child(0)
		fusions.remove_child(fusion)
		return fusion
	
	return null


func reset() -> void:
	get_fusion()
	
	while trefoils.get_child_count() > 0:
		var trefoil = trefoils.get_child(0)
		trefoils.remove_child(trefoil)
		trefoil.queue_free()
		Global.num.index.trefoil -= 1

#endregion


func shift_axises_index(shift_: int) -> void:
	Global.num.index.fusion -= 1
	get_fusion()
	var n = Global.dict.fringe.index.keys().size()
	axises.index = (axises.index + shift_ + n) % n
	design_shape()


func turn_fusion(shift_: int) -> void:
	var fusion = fusions.get_child(0)
	fusion.turn(shift_)


func flip_fusion() -> void:
	var fusion = fusions.get_child(0)
	fusion.flip()


func roll_fringe_index() -> void:
	axises.index = Global.get_random_key(Global.dict.fringe.weight) 


func get_cords_based_on_stars(stars_: Array) -> Array:
	var _cords = []
	
	for _i in stars_.size():
		var star_a = stars_[_i]
		var _j = (_i + 1) % stars_.size()
		var star_b = stars_[_j]
		
		for axis in Global.arr.axis:
			if star_a.grid[axis] == star_b.grid[axis]:
				var direction = Vector2()
				var mirror = Global.dict.axis.mirror[axis]
				var n = star_b.grid[mirror] - star_a.grid[mirror]
				direction[mirror] = sign(n)
				
				for _k in abs(n):
					var cord = star_a.directions[direction]
					_cords.append(cord)
					star_a = cord.get_another_star(star_a)
				break
	
	#_cords.sort_custom(func(a, b): return a.index.get_number() < b.index.get_number())
	return _cords


func design_shape_based_on_priority() -> void:
	var priority = sky.slots.priority.front()
	var cords = []
	var _trefoils = {}
	var data = {}
	data.comparison = "single"
	data.primary = 0
	
	for _i in priority.cords.size():
		var cord = priority.cords[_i]
		
		if !cord.trefoils.is_empty():
			var trefoil = cord.trefoils.front()
			
			if !_trefoils.has(trefoil):
				_trefoils[trefoil] = 0
			
			_trefoils[trefoil] += 1
	
	if _trefoils.keys().is_empty():
		data.primary = 1
		data.secondary = 2
		data.comparison = "none"
	else:
		var trefoil_a = _trefoils.keys().front()
		data.secondary = _trefoils[trefoil_a]
		
		if _trefoils.keys().size() > 1:
			var trefoil_b = _trefoils.keys().back()
			data.primary = _trefoils[trefoil_b]
			data.comparison = "same"
			
			if _trefoils[trefoil_b] > _trefoils[trefoil_a]:
				data.secondary = _trefoils[trefoil_b]
				data.primary = _trefoils[trefoil_a]
			
			if trefoil_b.vocation != trefoil_a.vocation:
				data.comparison = "different"
	
	set_fringe_index_based_on_cords(data)


func set_fringe_index_based_on_cords(data_: Dictionary) -> void:
	var indexs = []
	indexs.append_array(Global.dict.fringe.donor[data_.comparison])
	
	for _i in range(indexs.size()-1,-1,-1):
		var index = indexs[_i]
		var description = Global.dict.fringe.index[index]
		
		if data_.primary != description.donor.primary or data_.secondary != description.donor.secondary:
			indexs.erase(index)
	
	axises.index = indexs.pick_random()
