extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass


func _on_button_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
	self.queue_free()
	pass
