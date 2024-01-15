extends Polygon2D


#region vars
@onready var indexBlock = $IndexBlock
@onready var indexOrgan = $IndexOrgan

var proprietor = null
var stars = []
var cords = {}
var neighbors = {}
var grid = Vector2()
var socket = null
var kind = null
var status = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	for cord in input_.cords:
		cords[cord] = null
		cord.blocks.append(self)
		var star = cord.stars.front()
		
		if stars.has(star):
			star = cord.stars.back()
			
		stars.append(star)
		star.blocks.append(self)
		grid += star.grid
	
	grid -= Vector2.ONE * 2
	grid /= 4
	
	proprietor.grids.block[grid] = self
	
	init_indexs()
	set_vertexs()


func init_indexs() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.block
	indexBlock.set_attributes(input)
	Global.num.index.block += 1
	
	input.subtype = 0
	indexOrgan.set_attributes(input)


func set_vertexs() -> void:
	var vertexs = []
	
	for star in stars:
		var vertex = Vector2(star.position)
		vertexs.append(vertex)
		indexBlock.position += vertex / stars.size()
	
	set_polygon(vertexs)
	
	indexOrgan.position = indexBlock.position
#endregion


func paint_based_on_index() -> void:
	var hue = indexBlock.get_number() * 1.0 / Global.num.index.block
	color = Color.from_hsv(hue, 0.6, 0.7)

