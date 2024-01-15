extends Polygon2D


#region vars
@onready var index = $Index

var proprietor = null
var grid = null
var neighbors = {}
var cords = {}
var blocks = []
var directions = {}
var trefoils = []
var status = null
var temperature = null
var sides = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	grid = input_.grid
	
	init_basic_setting()


func init_basic_setting() -> void:
	position = grid * Global.num.cord.l -proprietor.center
	
	proprietor.grids.star[grid] = self
	set_vertexs()
	init_index()
	set_status("freely")
	temperature = "cold"


func set_vertexs() -> void:
	var order = "even"
	var corners = 4
	var r = Global.num.star.a
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.star
	index.set_attributes(input)
	Global.num.index.star += 1


func add_trefoil(trefoil_: Polygon2D) -> void:
	trefoils.append(trefoil_)
	
	set_status("occupied")


func set_status(status_: String) -> void:
	if status != "occupied":
		status = status_
		
		paint_to_match()
#endregion


func paint_to_match() -> void:
	color = Global.color.star[status]


func get_cords_around_socket_perimeter() -> Array:
	var stars = []
	
	for direction in Global.dict.neighbor.diagonal:
		var _grid = grid + direction
		var star = proprietor.grids.star[_grid]
		stars.append(star)
	
	var _cords = proprietor.get_cords_based_on_stars(stars)
	return _cords
