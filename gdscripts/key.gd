extends Collectable


@export var key_id = -1

var true_id = -1

# Coins are saved as integer variabes, keys are saved as Vector2i variables because they have 3 things to keep track of.
#
# True ID = Position inside the array. To access a key with the true id of 3, use something along the lines of "keys[3]".
# Key ID = The "X" value of the Vector2i element inside the save data.
# Save state = The "Y" value of the Vector2i element inside the save data.

func _ready():
	true_id = AreaManager.next_key_id
	AreaManager.next_key_id += 1


func collect():
	var tween = create_tween()
	
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.1)
	SFX.play("Key")
	
	GlobalSignal.update_checkpoint.emit()
	if key_id != -1:
		GlobalSignal.key_collected.emit(key_id)


func drop():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate:a", 1, 0.10)
	GlobalSignal.key_lost.emit(key_id)
