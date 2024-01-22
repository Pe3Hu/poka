extends MarginContainer


#region vars
@onready var left = $HBox/Left
@onready var libra = $HBox/Libra
@onready var right = $HBox/Right

var table = null
var gods = {}
var banner = null
var locks = []
var loser = null
var winner = null
var phase = null
var stage = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	table = input_.table


func init_basic_setting() -> void:
	banner = Global.arr.side.front()
	phase = Global.arr.phase.front()
	stage = Global.dict.phase.stage[phase].front()
	
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var god = table.gods.get_child(_i)#[_i]
		gods[god] = side
		var combo = get(side)
		god.combo = combo
		
		var input = {}
		input.croupier = self
		input.god = god
		combo.set_attributes(input)


func commence() -> void:
	init_basic_setting()
	
	follow_stage()
	#while table.loser == null:
	#	follow_stage()
#endregion


#region executive
func pass_banner() -> void:
	banner = Global.dict.chain.side[banner]
	var combo = get(banner)
	
	if !locks.has(combo.god):
		combo.risk_assessment()
		update_libra()
	else:
		pass_banner()
	
	if locks.size() == gods.keys().size() or loser != null:
		next_stage()


func update_libra() -> void:
	var input = {}
	input.type = "libra"
	
	if loser == null:
		var difference = left.amount.value.get_number() - right.amount.value.get_number()
		input.subtype = "equilibrium"
		
		if difference != 0:
			match sign(difference):
				1:
					input.subtype = "left"
				-1:
					input.subtype = "right"
	else:
		input.subtype = gods[winner] 
	
	libra.set_attributes(input)


func set_loser(loser_: MarginContainer) -> void:
	loser = loser_
	
	for god in gods:
		if god != loser:
			winner = god
			break
	
	#print([winner.health.index.get_number(), loser.health.index.get_number()])


func penalty_for_loser() -> void:
	if libra.subtype != "equilibrium":
		update_loser()
		var damage = 0
		
		for medal in Global.arr.medal:
			var god = get(medal)
			var side = gods[god]
			var combo = get(side)
			
			match medal:
				"winner":
					damage -= combo.amount.value.get_number()
				"loser":
					if combo.amount.value.get_number() <= combo.limit.value.get_number():
						damage += combo.amount.value.get_number()
		
		#print(damage)
		loser.health.change_integrity(damage)
		loser = null
		winner = null


func update_loser() -> void:
	if loser == null:
		for god in gods:
			if gods[god] != libra.subtype:
				set_loser(god)
				break

#endregion


#region order
func follow_stage() -> void:
	if table.loser == null:
		call(stage)


func next_stage() -> void:
	var index = Global.dict.phase.stage[phase].find(stage) + 1
	
	if index == Global.dict.phase.stage[phase].size():
		next_phase()
	else:
		stage = Global.dict.phase.stage[phase][index]


func next_phase() -> void:
	phase = Global.dict.chain.phase[phase]
	stage = Global.dict.phase.stage[phase].front()


func preparing() -> void:
	update_libra()
	
	for god in table.gods.get_children():
		god.gameboard.hand.refill()
	
	next_stage()


func balancing() -> void:
	if locks.size() < gods.keys().size() and loser == null:
		pass_banner()
	else:
		next_stage()


func reckoning() -> void:
	penalty_for_loser()
	
	for god in table.gods.get_children():
		god.gameboard.hand.discard()
		
		var side = gods[god]
		var combo = get(side)
		combo.reset()
	
	next_stage()
#endregion
