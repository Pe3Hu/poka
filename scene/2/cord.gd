extends Line2D


#region vars
@onready var index = $Index

var proprietor = null
var stars = []
var blocks = []
var trefoils = []
var status = null
var side = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	stars = input_.stars
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	set_vertexs()
	advance_status()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.cord
	index.set_attributes(input)
	Global.num.index.cord += 1


func set_vertexs() -> void:
	for star in stars:
		var vertex = star.position
		add_point(vertex)
		index.position += vertex
	
	index.position /= stars.size()
	index.position.x -= index.custom_minimum_size.x * 0.5
	index.position.y -= index.custom_minimum_size.y * 0.5


func advance_status() -> void:
	status = Global.dict.chain.status[status]
	paint_to_match()


func paint_to_match() -> void:
	default_color = Global.color.cord[status]
#endregion


func get_another_star(star_: Polygon2D) -> Variant:
	if stars.has(star_):
		for star in stars:
			if star != star_:
				return star
	
	return null


func update_axis() -> void:
	for axis in Global.arr.axis:
		var flag = true
		
		for star in stars:
			flag = flag and proprietor.axises.star[axis].has(star)
		
		if flag:
			proprietor.axises.cord[axis].append(self)
			update_side()


func update_side() -> void:
	var sides = {}
	
	for star in stars:
		for _side in star.sides:
			if !sides.has(_side):
				sides[_side] = 0
			
			sides[_side] += 1
	
	for _side in sides:
		if sides[_side] == 2:
			side = _side
			proprietor.sides.cord[side].append(self)


func add_trefoil(trefoil_: Polygon2D) -> void:
	trefoils.append(trefoil_)
