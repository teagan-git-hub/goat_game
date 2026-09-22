extends Area2D

func _on_body_entered(body):
	print("cow touched: ", get_parent().name)
	var enemy := get_parent() as Enemy

	if enemy == null:
		print("cow null")
		return

	if GameModeManager.instance != null:
		# start the battle with the enemy we just hit
		GameModeManager.instance.enter_battle(enemy)
