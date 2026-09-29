extends ProgressBar # Change this to CanvasLayer

func _ready() -> void:
	# Hide the entire layer by default when the game starts
	visible = false 
	value = 100
	
func _on_health_changed(new_health: int) -> void:
	value = new_health
