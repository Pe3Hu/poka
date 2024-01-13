extends Polygon2D


@onready var index = $Index

var constellation = null
var stars = null
var indent = null
var vocation = null
var crux = null
var square = null
var neighbors = []


func set_attributes(input_: Dictionary) -> void:
	constellation = input_.constellation
	stars = input_.stars
	
	init_basic_setting()


func init_basic_setting() -> void:
	constellation.trefoils.append(self)
	init_index()
	set_vertexs()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.trefoil
	index.set_attributes(input)
	Global.num.index.trefoil += 1


func set_vertexs() -> void:
	if indent == null:
		indent = Vector2(index.position)
	
	index.position = Vector2(indent)
	var vertexs = []
	
	for star in stars:
		var vertex = Vector2(star.position)
		vertexs.append(vertex)
		index.position += vertex / stars.size()
	
	set_polygon(vertexs)


func roll_vocation() -> void:
	var cruxs = []
	cruxs.append_array(Global.dict.vocation.crux.keys())
	
	for trefoil in constellation.trefoils:
		cruxs.erase(trefoil.crux)
	
	crux = cruxs.pick_random()
	vocation = Global.get_random_key(Global.dict.vocation.crux[crux])
	calculate_square()
	paint_based_on_vocation()


func paint_based_on_vocation() -> void:
	color = Global.color.vocation[vocation]


func paint_based_on_index() -> void:
	var hue = index.get_number() * 1.0 / Global.num.index.trefoil
	color = Color.from_hsv(hue, 0.6, 0.7)


func merge_with(trefoil_: Polygon2D) -> void:
	var trefoils = [self, trefoil_]
	var repeats = {}
	var singles = []
	
	for trefoil in trefoils:
		for star in trefoil.stars:
			if !repeats.has(star):
				repeats[star] = 0
			
			repeats[star] += 1
	
	stars = []
	for star in repeats.keys():
		if repeats[star] != 2:
			singles.append(star)
	
	for star in repeats:
		if repeats[star] == 2:
			var triplet = [star]
			triplet.append_array(singles)
			
			if !constellation.check_stars_on_one_side(triplet):
				stars.append_array(triplet)
				set_vertexs()
				break
	
	constellation.trefoils.erase(trefoil_)
	constellation.proprietor.trefoils.remove_child(trefoil_)
	constellation.gaps.append(trefoil_.index.get_number())
	trefoil_.queue_free()


func calculate_square() -> void:
	var a = stars[0].position
	var b = stars[1].position
	var c = stars[2].position
	square = int(abs(a.x * (b.y - c.y) + b.x *(c.y - a.y) + c.x * (a.y - b.y)) * 0.5 / Global.num.trefoil.square)


func revocation_from(trefoil_: Polygon2D) -> void:
	crux = trefoil_.crux
	vocation = trefoil_.vocation
	paint_based_on_vocation()
