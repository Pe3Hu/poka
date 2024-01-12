extends Polygon2D


@onready var index = $Index

var constellation = null
var stars = null


func set_attributes(input_: Dictionary) -> void:
	constellation = input_.constellation
	stars = input_.stars
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_index()
	set_vertexs()


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.trefoil
	index.set_attributes(input)
	Global.num.index.trefoil += 1


func set_vertexs() -> void:
	var vertexs = []
	
	for star in stars:
		var vertex = Vector2(star.position)
		vertexs.append(vertex)
		index.position += vertex / stars.size()
	
	set_polygon(vertexs)


func paint_based_on_index() -> void:
	var hue = index.get_number() * 1.0 / Global.num.index.trefoil
	color = Color.from_hsv(hue, 0.6, 0.7)
	
