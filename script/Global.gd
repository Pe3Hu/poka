extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.element = ["aqua", "wind", "fire", "earth"]
	arr.rank = [1, 2, 3, 4, 5]#, 6]
	arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.direction = ["up", "right", "down", "left"]
	arr.traveler = ["sage", "guardian"]
	arr.portal = ["frontier", "trap"]
	arr.scenery = ["forest of life", "field of death", "sea of souls"]
	arr.tower = ["harmony", "life", "death", "souls"]
	arr.content = ["decor", "cover"]
	arr.temperature = ["cold", "heat"]
	arr.indicator = ["health", "energy"]
	arr.organ = ["supplier", "fringe"]
	arr.axis = ["x", "y"]
	arr.side = ["up", "right", "down", "left"]


func init_num() -> void:
	num.index = {}
	num.index.star = 0
	num.index.cord = 0
	num.index.block = 0
	num.index.constellation = 0
	num.index.trefoil = 0
	
	
	num.sky = {}
	num.sky.col = 7
	num.sky.row = num.sky.col
	
	num.subsoil = {}
	num.subsoil.col = 3
	num.subsoil.row = num.subsoil.col
	
	num.star = {}
	num.star.a = 5
	num.star.quartet = 4
	
	num.cord = {}
	num.cord.l = 30


func init_dict() -> void:
	init_neighbor()
	init_corner()
	init_fringe()
	
	dict.side = {}
	dict.side.x = ["left", "right"]
	dict.side.y = ["up", "down"]
	
	dict.side.mirror = {}
	dict.side.mirror["up"] = "down"
	dict.side.mirror["down"] = "up"
	dict.side.mirror["left"] = "right"
	dict.side.mirror["right"] = "left"


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2 * PI * _i / corners_ - PI / 2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_fringe() -> void:
	dict.fringe = {}
	dict.fringe.index = {}
	dict.fringe.shape = {}
	
	var path = "res://asset/json/poka_fringe.json"
	var array = load_data(path)
	var exceptions = ["index", "shape"]
	
	for fringe in array:
		fringe.index = int(fringe.index)
		var data = {}
		data.size = Vector2()
		data.shape = fringe.shape
		
		for key in fringe:
			if !exceptions.has(key):
				data.size[key] = fringe[key]
		
		dict.fringe.index[fringe.index] = data
		
		if !dict.fringe.shape.has(fringe.shape):
			dict.fringe.shape[fringe.shape] = []
		
		dict.fringe.shape[fringe.shape].append(fringe.index)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	
	scene.star = load("res://scene/2/star.tscn")
	scene.cord = load("res://scene/2/cord.tscn")
	scene.block = load("res://scene/2/block.tscn")
	
	scene.constellation = load("res://scene/3/constellation.tscn")
	scene.trefoil = load("res://scene/3/trefoil.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(24, 16)
	
	vec.size.suit = Vector2(32, 32)
	vec.size.rank = Vector2(vec.size.sixteen)
	vec.size.box = Vector2(100, 100)
	
	vec.size.location = Vector2(60, 60)
	vec.size.scheme = Vector2(900, 700)
	vec.size.encounter = Vector2(128, 200)
	vec.size.facet = Vector2(64, 64) * 0.5
	vec.size.tattoo = Vector2(16, 16) * 3
	vec.size.essence = Vector2(16, 16) * 2
	vec.size.trigger = Vector2(16, 16) * 2
	vec.size.place = Vector2(16, 16) * 1.5
	
	vec.size.bar = Vector2(32, 16)
	vec.size.damage = Vector2(32, 32)
	
	vec.size.state = Vector2(100, 12)
	vec.size.tick = Vector2(5, 12)
	vec.size.stage = Vector2(vec.size.tick)
	
	vec.size.block = Vector2.ONE * num.cord.l
	vec.size.sky = Vector2(num.sky.col, num.sky.col) * num.cord.l
	vec.size.subsoil = Vector2(num.subsoil.col, num.subsoil.col) * num.cord.l
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = Color.from_hsv(160 / h, 0.6, 0.7)
	color.card.unselected = Color.from_hsv(0 / h, 0.4, 0.9)
	
	color.frontier = {}
	color.frontier.entry = Color.from_hsv(60 / h, 0.6, 0.7)
	color.frontier.exit = Color.from_hsv(30 / h, 0.6, 0.7)
	color.frontier.underside = Color.from_hsv(90 / h, 0.6, 0.7)
	#color.location.aisle = Color.from_hsv(60 / h, 0.6, 0.7)
	
	color.route = {}
	color.route.active = Color.from_hsv(330 / h, 0.6, 0.7)
	color.route.passive = Color.from_hsv(30 / h, 0.6, 0.7)
	
	color.traveler = {}
	color.traveler.guardian = Color.from_hsv(0 / h, 0.6, 0.7)
	color.traveler.sage = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.difficulty = Color.from_hsv(150 / h, 0.6, 0.7)
	
	color.scenery = {}
	color.scenery["forest of life"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.scenery["field of death"] = Color.from_hsv(270 / h, 0.6, 0.7)
	color.scenery["sea of souls"] = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.tower = {}
	color.tower["life"] = Color.from_hsv(0 / h, 0.6, 0.7)
	color.tower["death"] = Color.from_hsv(120 / h, 0.6, 0.7)
	color.tower["souls"] = Color.from_hsv(60 / h, 0.6, 0.7)
	color.tower["harmony"] = Color.from_hsv(270 / h, 0.6, 0.7)
	
	color.cord = {}
	color.cord.decor = Color.from_hsv(210 / h, 0.9, 0.7)
	color.cord.cover = Color.from_hsv(120 / h, 0.9, 0.7)
	color.cord.heat = Color.from_hsv(0 / h, 0.9, 0.7)
	
	color.block = {}
	color.block.decor = Color.from_hsv(120 / h, 0.8, 0.4)
	color.block.cover = Color.from_hsv(210 / h, 0.8, 0.4)
	color.block.insulation = Color.from_hsv(270 / h, 0.8, 0.4)
	color.block.freely = Color.from_hsv(0 / h, 0.0, 0.9)
	
	color.star = {}
	color.star.occupied = Color.from_hsv(60 / h, 0.9, 0.9)
	color.star.freely = Color.from_hsv(30 / h, 0.9, 0.9)
	color.star.insulation = Color.from_hsv(270 / h, 0.9, 0.9)
	
	color.star.cold = Color.from_hsv(150 / h, 0.9, 0.7)
	color.star.heat = Color.from_hsv(0 / h, 0.9, 0.7)
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(0, 0.5, 0.9)
	color.indicator.energy = {}
	color.indicator.energy.fill = Color.from_hsv(60 / h, 0.9, 0.7)
	color.indicator.energy.background = Color.from_hsv(60 / h, 0.5, 0.9)
	
	color.role = {}
	color.role.damager = Color.from_hsv(270 / h, 0.9, 0.9)
	color.role.charger = Color.from_hsv(30 / h, 0.9, 0.9)
	color.role.repairer = Color.from_hsv(120 / h, 0.9, 0.9)
	
	color.flow = {}
	color.flow.fringe = Color.from_hsv(300 / h, 0.9, 0.9)
	color.flow.supplier = Color.from_hsv(90 / h, 0.9, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null