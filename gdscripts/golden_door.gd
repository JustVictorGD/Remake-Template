extends Door

@export var coin_requirement := -1

func _ready():
	setup_size()
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.coin_collected.connect(coin_collected)
	
	
	
	if self.coin_requirement <= 0:
		self.coin_requirement = AreaManager.coin_requirement
	
	if AreaManager.coins_collected >= self.coin_requirement:
		stay_open()



func coin_collected():
	
	if AreaManager.coins_collected >= self.coin_requirement and not opened:
		open()



func player_respawn():
	if AreaManager.coins_collected < self.coin_requirement and opened:
		close()
