extends Polygon2D


#region vars
@onready var index = $Index

var proprietor = null
var core = null
var stars = []
var blocks = []
var neighbors = []
var grid = Vector2()
var status = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	core = input_.core
	
	init_basic_setting()


func init_basic_setting() -> void:
	for direction in Global.dict.neighbor.diagonal:
		var _grid = core.grid + direction
		var star = proprietor.grids.star[_grid]
		stars.append(star)
	
	grid = core.grid - Vector2.ONE
	grid /= 2
	
	#for direction in Global.dict.neighbor.zero:
		#var _grid = grid + direction
		#if proprietor.grids.block.has(_grid):
		#var block = proprietor.grids.block[_grid]
	
	for block in core.blocks:
		blocks.append(block)
		block.socket = self
	
	proprietor.grids.socket[grid] = self
	
	init_indexs()
	set_vertexs()
	set_status("unavailable")


func init_indexs() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.socket
	index.set_attributes(input)
	Global.num.index.socket += 1


func set_vertexs() -> void:
	var vertexs = []
	
	for star in stars:
		var vertex = Vector2(star.position)
		vertexs.append(vertex)
		index.position += vertex / stars.size()
	
	set_polygon(vertexs)


func set_status(status_: String) -> void:
	status = status_
	
	paint_to_match()
#endregion


func paint_to_match() -> void:
	color = Global.color.socket[status]


func paint_based_on_index() -> void:
	var hue = index.get_number() * 1.0 / Global.num.index.socket
	color = Color.from_hsv(hue, 0.6, 0.7)

