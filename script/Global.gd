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
	arr.side = ["left", "right"]
	arr.turn = ["counterclockwise", "clockwise"]
	arr.state = ["vigor", "standard", "fatigue"]
	arr.medal = ["winner", "loser"]
	arr.phase = ["dawn", "noon", "dusk"]


func init_num() -> void:
	num.index = {}
	num.index.god = 0
	num.index.card = 0
	num.index.star = 0
	num.index.cord = 0
	num.index.block = 0
	num.index.socket = 0
	num.index.fusion = 0
	num.index.trefoil = 0
	
	num.socket = {}
	num.socket.half = 2
	num.socket.n = num.socket.half * 2 + 1
	
	num.sky = {}
	num.sky.col = num.socket.n * 2 + 1 
	num.sky.row = num.sky.col
	
	num.subsoil = {}
	num.subsoil.col = 3
	num.subsoil.row = num.subsoil.col
	
	num.star = {}
	num.star.a = 5
	num.star.quartet = 4
	
	num.cord = {}
	num.cord.l = 30
	
	num.trefoil = {}
	num.trefoil.square = num.cord.l * num.cord.l * 0.5
	
	num.mirage = {}
	num.mirage.flips = 2
	num.mirage.turns = 4
	
	num.apotheosis = {}
	num.apotheosis.amount = 24


func init_dict() -> void:
	init_chain()
	init_side()
	init_corner()
	init_card()
	init_neighbor()
	init_fringe()
	init_vocation()
	init_token()
	init_performer()


func init_chain() -> void:
	dict.chain = {}
	dict.chain.status = {}
	dict.chain.status[null] = "unavailable"
	dict.chain.status["unavailable"] = "available"
	dict.chain.status["available"] = "incomplete"
	dict.chain.status["incomplete"] = "completed"
	
	dict.chain.area = {}
	dict.chain.area[null] = "discharged"
	dict.chain.area["discharged"] = "available"
	dict.chain.area["available"] = "hand"
	dict.chain.area["hand"] = "discharged"
	dict.chain.area["broken"] = "discharged"
	
	dict.chain.side = {}
	dict.chain.side["right"] = "left"
	dict.chain.side["left"] = "right"
	
	dict.chain.state = {}
	dict.chain.state["fatigue"] = "standard"
	dict.chain.state["standard"] = "vigor"
	dict.chain.state["vigor"] = null
	
	dict.chain.phase = {}
	dict.chain.phase["dawn"] = "noon"
	dict.chain.phase["noon"] = "dusk"
	dict.chain.phase["dusk"] = "dawn"
	
	dict.donor = {}
	dict.donor.area = {}
	dict.donor.area["available"] = "discharged"
	dict.donor.area["hand"] = "available"
	
	dict.donor.state = {}
	dict.donor.state["vigor"] = "standard"
	dict.donor.state["standard"] = "fatigue"
	dict.donor.state["fatigue"] = null
	
	dict.phase = {}
	dict.phase.stage = {}
	dict.phase.stage["dawn"] = ["preparing"]
	dict.phase.stage["noon"] = ["balancing"]
	dict.phase.stage["dusk"] = ["reckoning"]


func init_side() -> void:
	dict.side = {}
	dict.side.x = ["left", "right"]
	dict.side.y = ["up", "down"]
	
	dict.side.mirror = {}
	dict.side.mirror["up"] = "down"
	dict.side.mirror["down"] = "up"
	dict.side.mirror["left"] = "right"
	dict.side.mirror["right"] = "left"
	
	dict.axis = {}
	dict.axis.mirror = {}
	dict.axis.mirror["x"] = "y"
	dict.axis.mirror["y"] = "x"


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


func init_card() -> void:
	arr.rank = [3, 4, 6, 8, 12]
	dict.card = {}
	dict.card.count = {}
	arr.performer = ["heretic"]#["clubs", "diamonds", "hearts", "spades"]
	
	for rank in arr.rank:
		dict.card.count[rank] = num.apotheosis.amount / rank


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


func init_fringe() -> void:
	dict.fringe = {}
	dict.fringe.index = {}
	dict.fringe.shape = {}
	dict.fringe.weight = {}
	dict.fringe.donor = {}
	
	var path = "res://asset/json/poka_fringe.json"
	var array = load_data(path)
	var exceptions = ["index"]
	
	for fringe in array:
		fringe.index = int(fringe.index)
		var data = {}
		data.donor = {}
		
		for key in fringe:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.has("donor"):
					data.donor[words[1]] = fringe[key]
				else:
					data[key] = fringe[key]
		
		if data.donor.keys().is_empty():
			data.erase("donor")
		else:
			if !dict.fringe.donor.has(data.donor.comparison):
				dict.fringe.donor[data.donor.comparison] = []
			
			dict.fringe.donor[data.donor.comparison].append(fringe.index)
		
		dict.fringe.index[fringe.index] = data
		dict.fringe.weight[fringe.index] = fringe.index
		
		if !dict.fringe.shape.has(fringe.shape):
			dict.fringe.shape[fringe.shape] = []
		
		dict.fringe.shape[fringe.shape].append(fringe.index)


func init_vocation() -> void:
	dict.vocation = {}
	dict.vocation.title = {}
	dict.vocation.crux = {}
	color.vocation = {}
	
	var path = "res://asset/json/poka_vocation.json"
	var array = load_data(path)
	var exceptions = ["title", "hue"]
	
	for vocation in array:
		var data = {}
		
		for key in vocation:
			if !exceptions.has(key):
				data[key] = vocation[key]
		
		dict.vocation.title[vocation.title] = data
		
		if !dict.vocation.crux.has(vocation.crux):
			dict.vocation.crux[vocation.crux] = {}
		
		dict.vocation.crux[vocation.crux][vocation.title] = vocation.rarity
		color.vocation[vocation.title] = Color.from_hsv(vocation.hue / 360.0, 0.9, 0.7)


func init_token() -> void:
	dict.token = {}
	dict.token.title = {}
	
	var path = "res://asset/json/poka_token.json"
	var array = load_data(path)
	var exceptions = ["title"]
	
	for token in array:
		var data = {}
		
		for key in token:
			if !exceptions.has(key):
				data[key] = token[key]
		
		dict.token.title[token.title] = data


func init_performer() -> void:
	dict.performer = {}
	dict.performer.token = {}
	
	var path = "res://asset/json/poka_performer.json"
	var array = load_data(path)
	var exceptions = ["title", "token"]
	
	for performer in array:
		var data = {}
		
		for key in performer:
			if !exceptions.has(key):
				data[key] = performer[key]
				
				if typeof(performer[key]) == TYPE_FLOAT:
					data[key] = int(performer[key])
		
		if !dict.performer.token.has(performer.title):
			dict.performer.token[performer.title] = {}
		
		dict.performer.token[performer.title][performer.token] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.star = load("res://scene/2/star.tscn")
	scene.cord = load("res://scene/2/cord.tscn")
	scene.block = load("res://scene/2/block.tscn")
	scene.socket = load("res://scene/2/socket.tscn")
	
	scene.fusion = load("res://scene/3/fusion.tscn")
	scene.trefoil = load("res://scene/3/trefoil.tscn")
	
	scene.mirage = load("res://scene/4/mirage.tscn")
	
	scene.card = load("res://scene/5/card.tscn")
	scene.token = load("res://scene/5/token.tscn")
	
	scene.table = load("res://scene/6/table.tscn")
	scene.pawn = load("res://scene/6/pawn.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.suit = Vector2(32, 32)
	vec.size.rank = Vector2(vec.size.sixteen)
	vec.size.combo = Vector2(vec.size.sixteen) * 2
	vec.size.god = Vector2(vec.size.sixteen) * 3
	vec.size.libra = Vector2(vec.size.sixteen) * 4
	vec.size.performer = Vector2(32, 32)
	vec.size.pawn = Vector2(32, 32)
	vec.size.indicator = Vector2(32, 32)
	vec.size.power = Vector2(vec.size.sixteen) * 1.5
	vec.size.border = Vector2(vec.size.power)
	vec.size.token = Vector2(48, 48)
	vec.size.target = Vector2(64, 64)
	
	
	vec.size.state = Vector2(128, 16)
	
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
	
	color.cord = {}
	color.cord.unavailable = Color.from_hsv(30 / h, 0.6, 0.7)
	color.cord.available = Color.from_hsv(210 / h, 0.9, 0.7)
	color.cord.incomplete = Color.from_hsv(0 / h,  0.9, 0.7)
	color.cord.completed = Color.from_hsv(270 / h, 0.9, 0.7)
	
	color.star = {}
	color.star.occupied = Color.from_hsv(60 / h, 0.9, 0.9)
	color.star.freely = Color.from_hsv(30 / h, 0.9, 0.9)
	color.star.insulation = Color.from_hsv(270 / h, 0.9, 0.9)
	
	color.star.cold = Color.from_hsv(150 / h, 0.9, 0.7)
	color.star.heat = Color.from_hsv(0 / h, 0.9, 0.7)
	
	color.socket = {}
	color.socket.unavailable = Color.from_hsv(0 / h, 0.0, 0.3)
	color.socket.available = Color.from_hsv(0 / h, 0.0, 0.9)
	color.socket.incomplete = Color.from_hsv(0 / h, 0.0, 0.6)
	color.socket.completed = Color.from_hsv(0 / h, 0.0, 0.1)
	
	color.state = {}
	color.state.vigor = {}
	color.state.vigor.fill = Color.from_hsv(120 / h, 1, 0.9)
	color.state.vigor.background = Color.from_hsv(120 / h, 0.25, 0.9)
	color.state.standard = {}
	color.state.standard.fill = Color.from_hsv(30 / h, 1, 0.9)
	color.state.standard.background = Color.from_hsv(30 / h, 0.25, 0.9)
	color.state.fatigue = {}
	color.state.fatigue.fill = Color.from_hsv(0, 1, 0.9)
	color.state.fatigue.background = Color.from_hsv(0, 0.25, 0.9)


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
