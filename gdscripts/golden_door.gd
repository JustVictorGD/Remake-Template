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
	
	print(self.coin_requirement)



func coin_collected():
	
	print(str(AreaManager.coins_collected) + "/" + str(self.coin_requirement))
	
	if AreaManager.coins_collected >= self.coin_requirement:
		print("REQUIREMENT MET")
		if not opened:
			print("OPEN")
			open()



func player_respawn():
	if AreaManager.coins_collected < self.coin_requirement:
		print("REQUIREMENT NOT MET")
		if opened:
			print("CLOSE")
			close()
