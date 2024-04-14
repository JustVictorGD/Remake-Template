extends CharacterBody2D

@export_category("Player Settings")
@export var speed = 4
var death = false

@export_category("Cheats")
@export var invincible = false # Should be false. Change to true for testing.
@export var can_teleport = false




func _ready():
	GlobalSignal.speed_changed.connect(speed_changed)


func _on_area_2d_area_entered(area):
	if "Enemies" in area.get_groups() and invincible == false:
		enemy_death()
	
	if "Finish" in area.get_groups() and AreaManager.requirement_met:
		if not GameState.finish_touched:
			win()


func enemy_death():
	death = true
	invincible = true
	
	var tween = create_tween()
	tween.tween_property($CanvasGroup,"self_modulate:a", 0, 0.50)
	SFX.play("EnemyDeath")
	$RespawnTimer.start()
	
	GlobalSignal.player_death.emit()


func pit_death():
	pass


func water_death():
	pass


func win():
	var tween = create_tween()
	tween.tween_property($CanvasGroup,"self_modulate:a", 0, 1)
	
	invincible = true
	GameState.finish_touched = true






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

func speed_changed(new_speed):
	speed = new_speed


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
		
		AreaManager.player_position.x = self.position.x
		AreaManager.player_position.y = AreaManager.area_size.y * 50 - 22
	
	
	if position.x < 22:
		AreaManager.area_left()
		
		AreaManager.player_position.x = AreaManager.area_size.x * 50 - 22
		AreaManager.player_position.y = self.position.y
	
	
	if position.y > AreaManager.area_size.y * 50 - 22:
		AreaManager.area_down()
		
		AreaManager.player_position.x = self.position.x
		AreaManager.player_position.y = 22
	
	
	if position.x > AreaManager.area_size.x * 50 - 22:
		AreaManager.area_right()
		
		AreaManager.player_position.x = 22
		AreaManager.player_position.y = self.position.y

