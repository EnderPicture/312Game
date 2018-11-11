extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func show_top():
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		Vector2(0,$"..".rect_size.y),
		.5, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0)
	$Tween.start()
	
func show_bottom():
	$Tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		Vector2(0,0),
		.5, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0)
	$Tween.start()
	