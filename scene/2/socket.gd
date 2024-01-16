extends Polygon2D


#region vars
@onready var index = $Index

var proprietor = null
var core = null
var stars = []
var blocks = []
var neighbors = []
var cords = []
var grid = Vector2()
var status = null
var restraints = []
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
	
	for block in core.blocks:
		blocks.append(block)
		block.socket = self
	
	proprietor.grids.socket[grid] = self
	
	init_indexs()
	set_vertexs()
	advance_status()
	cords = core.get_cords_around_socket_perimeter()


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


func advance_status() -> void:
	status = Global.dict.chain.status[status]
	paint_to_match()
#endregion


#region paint
func paint_to_match() -> void:
	color = Global.color.socket[status]


func paint_based_on_index() -> void:
	var hue = index.get_number() * 1.0 / Global.num.index.socket
	color = Color.from_hsv(hue, 0.6, 0.7)
#endregion


func add_restraint(socket_: Polygon2D) -> void:
	if status == "available":
		restraints.append(socket_)
		
		if restraints.size() == 2:
			proprietor.slots.priority.append(self)
