extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var type = ""

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func react():
	$"StaticBody2D/CollisionShape2D".queue_free()
	$"LightOccluder2D".queue_free()
	z_index = -1
	modulate = Color(1,1,1,.25)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
