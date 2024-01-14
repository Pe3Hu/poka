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
	set_status("freely")


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


func set_status(status_: String) -> void:
	status = status_
	
	paint_to_match()
#endregion


func set_kind(kind_: String) -> void:
	kind = kind_
	
	paint_to_match()


func paint_to_match() -> void:
	if kind == null:
		color = Global.color.block[status]
	else:
		color = Global.color.block[kind]


func update_kind() -> void:
	status = "occupied"
	var kinds = {}
	
	for cord in cords:
		if !kinds.has(cord.kind):
			kinds[cord.kind] = 1
		else:
			kinds[cord.kind] += 1
	
	var _kind = "cover"
	
	if kinds.decor >= 2:
		_kind = "decor"
	
	set_kind(_kind)


func switch_indexs() -> void:
	indexBlock.visible = !indexBlock.visible
	indexOrgan.visible = !indexOrgan.visible


func paint_based_on_index() -> void:
	var hue = indexBlock.get_number() * 1.0 / Global.num.index.block
	color = Color.from_hsv(hue, 0.6, 0.7)

