extends ParallaxBackground

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var offsetLoc = 0

func _ready():
	set_process(true)
	
func _process(delta):
	offsetLoc = offsetLoc + 50 * delta
	set_scroll_offset(Vector2(0, offsetLoc))
	
	
