extends CharacterBody2D
@onready var goat_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction=Input.get_vector("left", "right", "up", "down")
	var h_direction := Input.get_axis("left", "right")
	velocity=direction*300
	move_and_slide()

	if velocity.length()>0.0: 
		goat_2d.play("walk_animation")
		if h_direction < 0:
			goat_2d.flip_h = true
		else: 
			goat_2d.flip_h = false
	else:
		goat_2d.play("idle_animation")


# when we collide with an enemy
func _on_area_2d_area_entered(area: Area2D) -> void:
	# Get the enemy (node parent) of the collider touched
	var enemy := area.get_parent() as Enemy

	if enemy == null:
		return

	if GameModeManager.instance != null:
		# start the battle with the enemy we just hit
		GameModeManager.instance.enter_battle(enemy)
