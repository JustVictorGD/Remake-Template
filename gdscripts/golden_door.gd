extends Door


var opened = false

func _ready():
	GlobalSignal.coin_requirement_met.connect(requirement_met)
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.player_death.connect(player_death)
	
	setup_size()

func requirement_met():
	collision_shape.disabled = true
	opened = true
	open()

func player_death():
	pass

func player_respawn():
	if opened and GameState.uncollected_coins.size() > 0:
		close()
