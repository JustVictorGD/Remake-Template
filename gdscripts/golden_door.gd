extends Door



func _ready():
	GlobalSignal.coin_requirement_met.connect(requirement_met)
	GlobalSignal.coin_requirement_lost.connect(requirement_lost)
	GlobalSignal.player_death.connect(player_death)
	
	setup_size()
	
	if AreaManager.requirement_met:
		stay_open()

func requirement_met():
	collision_shape.set_deferred("disabled", true)
	open()

func player_death():
	pass

func requirement_lost():
	close()

func _physics_process(delta):
	pass
