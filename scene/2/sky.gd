extends MarginContainer


#region vars
@onready var bg = $BG
@onready var stars = $Stars
@onready var cords = $Cords
@onready var blocks = $Blocks
@onready var trefoils = $Trefoils
@onready var sockets = $Sockets

var horizon = null
var center = null
var grids = {}
var rings = {}
var slots = {}
#endregion


func set_attributes(input_: Dictionary) -> void:
	horizon = input_.horizon
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.sky)
	center = custom_minimum_size * 0.5
	
	init_stars()
	init_cords()
	init_blocks()
	init_sockets()
	trefoils.position = center


#region init star and cord scenes
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
#endregion


#region init block scenes
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
		
		if _cords.size() == Global.num.star.quartet:
			add_block(_cords)
	
	init_blocks_neighbors()


func add_block(_cords: Array) -> void:
	var input = {}
	input.proprietor = self
	input.cords = _cords
	
	var block = Global.scene.block.instantiate()
	blocks.add_child(block)
	block.set_attributes(input)


func init_blocks_neighbors() -> void:
	var n = 2
	
	for cord in cords.get_children():
		if cord.blocks.size() == n:
			for _i in n:
				var block = cord.blocks[_i]
				var neighbor = cord.blocks[(_i + 1) % n]
				block.neighbors[neighbor] = cord
#endregion


#region init socket scenes
func init_sockets() -> void:
	grids.socket = {}
	sockets.position = center
	slots.unavailable = []
	slots.available = []
	slots.incomplete = []
	slots.completed = []
	
	for _i in range(1, Global.num.sky.row, 2):
		for _j in range(1, Global.num.sky.col, 2):
			var input = {}
			input.proprietor = self
			input.core = grids.star[Vector2(_j, _i)]
	
			var socket = Global.scene.socket.instantiate()
			sockets.add_child(socket)
			socket.set_attributes(input)
			slots.unavailable.append(socket)
	
	init_sockets_neighbors()
	var grid = Vector2.ONE * Global.num.socket.half 
	var socket = grids.socket[grid]
	update_slots(socket)


func init_sockets_neighbors() -> void:
	for socket in sockets.get_children():
		for block in socket.blocks:
			for neighbor in block.neighbors:
				if neighbor.socket != socket and !socket.neighbors.has(neighbor.socket):
					socket.neighbors.append(neighbor.socket)
					neighbor.socket.neighbors.append(socket)


func update_slots(socket_: Polygon2D) -> void:
	advance_socket(socket_)
	
	for neighbor in socket_.neighbors:
		if slots.unavailable.has(neighbor):
			advance_socket(neighbor)


func advance_socket(socket_: Polygon2D) -> void:
	var status = String(socket_.status)
	slots[status].erase(socket_)
	
	for cord in socket_.cords:
		if cord.status == socket_.status:
			cord.advance_status()
	
	socket_.advance_status()
	slots[socket_.status].append(socket_)


func trefoil_transfer(trefoil_: Polygon2D, socket_: Polygon2D) -> void:
	trefoils.add_child(trefoil_)
	
	for _i in trefoil_.stars.size():
		var star = trefoil_.stars.pop_front()
		var grid = socket_.core.grid + star.grid - Vector2.ONE
		star = grids.star[grid]
		trefoil_.stars.append(star)
	
	trefoil_.set_vertexs()
	var _cords = get_cords_based_on_stars(trefoil_.stars)
	
	for cord in _cords:
		cord.add_trefoil(trefoil_)
#endregion


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
