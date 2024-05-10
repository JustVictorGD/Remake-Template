extends Door


@export_category("Normal Door Property")
## Use this to connect the door to a key. A normal door with the Connection ID of 1 will be opened by any key that has its ID set to 1.
@export var connection_id = -1

func _ready():
	setup_size()
	
	GlobalSignal.key_collected.connect(key_collected)
	GlobalSignal.key_lost.connect(key_lost)
	GlobalSignal.open_doors_in_cutscenes.connect(cutscene_open)
	
	if connection_id >= 0:
		for level in AreaManager.save_data:
			for area in AreaManager.save_data[level]:
				for key in AreaManager.save_data[level][area]["keys"]:
					if key.x == connection_id and key.y != 0 and AreaManager.cutscene_info["key_collected"] != connection_id and not opened:
						stay_open()

func cutscene_open():
	if owner.in_cutscene and AreaManager.cutscene_info["key_collected"] == connection_id:
		open()


func key_collected(key_id):
	if key_id == connection_id:
		open()


func key_lost(key_id):
	if key_id == connection_id:
		close()

