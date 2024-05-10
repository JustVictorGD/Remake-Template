extends Control



func _ready():
	GlobalSignal.player_respawn.connect(player_respawn)

func player_respawn():
	$Deaths.text = "Deaths: " + str(AreaManager.deaths)

func _physics_process(delta):
	$Timer.text = AreaManager.time_string
	$MillisecondTimer.text = AreaManager.millisecond_string

