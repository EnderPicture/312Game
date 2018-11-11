extends CanvasLayer

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


func _on_Button_pressed():
	var height = get_tree().root.get_visible_rect().size.y
	$"Tween".interpolate_property(self, "offset", offset, Vector2(0,height), .5, Tween.TRANS_QUAD ,Tween.EASE_OUT, 0)
	$"Tween".start()
	#queue_free()



func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # replace with function body
