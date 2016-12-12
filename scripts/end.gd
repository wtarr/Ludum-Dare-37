extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var time_completed = ""

func _ready():
	
	var elapsed = global.end_time - global.start_time
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	time_completed = "Escape time: %02d : %02d" % [minutes, seconds]
	get_node("time_to_beat").set_text(time_completed)
	pass


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/main.tscn")
	self.queue_free()
