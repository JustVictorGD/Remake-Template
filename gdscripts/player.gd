extends CharacterBody2D


var speed = 4
var death = false

@export_category("Cheats")
@export var invincible = false # Should be false. Change to true for testing.
@export var can_teleport = false



func _physics_process(delta):
	if death == false:
		if Input.is_action_pressed("right"):
			position.x += speed
		
		if Input.is_action_pressed("down"):
			position.y += speed
		
		if Input.is_action_pressed("left"):
			position.x -= speed
		
		if Input.is_action_pressed("up"):
			position.y -= speed
	
	if Input.is_action_just_pressed("teleport") and can_teleport:
		position = get_global_mouse_position()
	
	move_and_slide()
	
	if position.y < 22:
		AreaManager.area_up()
	if position.x < 22:
		AreaManager.area_left()
	if position.y > AreaManager.area_size.y * 50 - 22:
		AreaManager.area_down()
	if position.x > AreaManager.area_size.x * 50 - 22:
		AreaManager.area_right()
	
	AreaManager.player_position = self.position



func _on_area_2d_area_entered(area):
	var area_groups = area.get_groups()
	
	if "Enemies" in area_groups:
		if invincible == false:
			death = true
			invincible = true
			
			var tween = create_tween()
			tween.tween_property($CanvasGroup,"self_modulate:a", 0, 0.50)
			
			SFX.play("EnemyDeath")
			$RespawnTimer.start()
			
			GlobalSignal.player_death.emit()
	
	
	if "Finish" in area_groups and GameState.collected_coins.size() + GameState.saved_coins.size() > GameState.coin_requirement - 1:
		if not GameState.finish_touched:
			#var tween = create_tween()
			#tween.tween_property($Sprite2D,"modulate:a", 0, 1)
			
			invincible = true
			GameState.finish_touched = true
			$Camera2D.enabled = false



func _on_respawn_timer_timeout():
	position = GameState.respawn_pos
	
	death = false
	
	var tween = create_tween()
	tween.tween_property($CanvasGroup,"self_modulate:a", 1, 0.25)
	
	GlobalSignal.player_respawn.emit()
	
	$Extra50ms.start()

func _on_extra_100_ms_timeout():
	invincible = false


func _on_player_area_entered(area: Area2D):
	if area.has_method("touched_by_player"):
		area.touched_by_player()
