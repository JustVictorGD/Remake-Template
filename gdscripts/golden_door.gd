extends Door

## If you want the door to open when everything in the level is collected, simply keep the value at 0,
## the requirement will become the total amount of money in the level.
## If you want to set the requirement to a specific number, change the value to a positive number, and that will become the requirement.
## As a QoL feature, you can also input negative numbers. -4 will set the requirement to 4 less than the total amount of money, always.
@export var money_requirement := 0

func _ready():
	setup_size()
	
	GlobalSignal.player_respawn.connect(player_respawn)
	GlobalSignal.coin_collected.connect(coin_collected)
	GlobalSignal.open_doors_in_cutscenes.connect(cutscene_open)
	
	if self.money_requirement <= 0:
		self.money_requirement = AreaManager.money["requirement"] + self.money_requirement
	
	if AreaManager.money["amount"] >= self.money_requirement and owner.in_cutscene == false:
		stay_open()
	
	#if Vector2i(self.money_requirement, 0) not in AreaManager.money_requirements:
	#	AreaManager.money_requirements.append(Vector2i(self.money_requirement, 0))

func cutscene_open():
	if owner.in_cutscene and AreaManager.cutscene_info["money_reached"] == money_requirement:
		open()

func coin_collected():
	
	if AreaManager.money["amount"] >= self.money_requirement and not opened:
		open()



func player_respawn():
	if AreaManager.money["amount"] < self.money_requirement and opened:
		close()
