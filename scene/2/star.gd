extends Polygon2D


@onready var index = $Index

var proprietor = null
var grid = null
var neighbors = {}
var cords = {}
var blocks = []
var directions = {}
var constellations = []
var status = null
var temperature = null
var sides = []


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


func add_constellation(constellation_: MarginContainer) -> void:
	constellations.append(constellation_)
	
	set_status("occupied")


func set_status(status_: String) -> void:
	if status != "occupied":
		status = status_
		
		paint_to_match()


func paint_to_match() -> void:
	color = Global.color.star[status]
