extends Polygon2D


#region vars
@onready var index = $Index

var fusion = null
var stars = null
var indent = null
var vocation = null
var crux = null
var square = null
var neighbors = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	fusion = input_.fusion
	stars = input_.stars
	
	init_basic_setting()


func init_basic_setting() -> void:
	fusion.trefoils.append(self)
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

#endregion


func roll_vocation() -> void:
	var cruxs = []
	cruxs.append_array(Global.dict.vocation.crux.keys())
	
	for trefoil in fusion.trefoils:
		cruxs.erase(trefoil.crux)
	
	if cruxs.is_empty():
		cruxs.append_array(Global.dict.vocation.crux.keys())
	
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
			
			if !fusion.check_stars_on_one_side(triplet):
				stars.append_array(triplet)
				set_vertexs()
				break
	
	fusion.trefoils.erase(trefoil_)
	fusion.proprietor.trefoils.remove_child(trefoil_)
	fusion.gaps.append(trefoil_.index.get_number())
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


func turn(direction_: String) -> void:
	var turned_stars = []
	
	for star in stars:
		var _star = fusion.proprietor.turns.star[direction_][star]
		turned_stars.append(_star)
	
	stars = turned_stars
	set_vertexs()


func flip() -> void:
	var fliped_stars = []
	
	for star in stars:
		var _star = fusion.proprietor.flips.star[star]
		fliped_stars.append(_star)
	
	stars = fliped_stars
	set_vertexs()


func repetition_check_based_on_trefoil(trefoil_: Polygon2D) -> bool:
	var trefoils = [self, trefoil_]
	var indexs = {}
	
	for trefoil in trefoils:
		indexs[trefoil] = []
		
		for star in trefoil.stars:
			var index = star.index.get_number()
			indexs[trefoil].append(index)
		
		indexs[trefoil].sort_custom(func(a, b): return a < b)
	
	for _i in indexs[self].size():
		if indexs[self][_i] != indexs[trefoil_][_i]:
			return false
	
	return true


func repetition_check_on_rotation(flips_: int, turns_: int) -> bool:
	var rotated_stars = []
	var indexs = {}
	indexs.original = []
	indexs.rotated = []
	
	for star in stars:
		var index = star.index.get_number()
		indexs.original.append(index)
		var _star = star
		
		for _i in flips_:
			_star = fusion.proprietor.flips.star[_star]
		
		for _i in turns_:
			_star = fusion.proprietor.turns.star["clockwise"][_star]
		
		index = _star.index.get_number()
		indexs.rotated.append(index)
	
	for key in indexs:
		indexs[key].sort_custom(func(a, b): return a < b)
	
	for _i in indexs.original.size():
		if indexs.original[_i] != indexs.rotated[_i]:
			return false
	
	return true
