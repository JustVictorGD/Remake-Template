extends Door


var opened = false

func _ready():
	GlobalSignal.coin_requirement_met.connect(requirement_met)
	GlobalSignal.player_respawn.connect(player_respawn)
	
	setup_size()

func requirement_met():
	collision_shape.disabled = true
	opened = true
	open()


func player_respawn():
	if opened and GameState.uncollected_coins.size() > 0:
		close()
