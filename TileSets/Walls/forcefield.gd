extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var r = .4
var g = .5
var b = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	modulate = Color(r,g,b)
	$AnimationPlayer.current_animation = "noise"
	
	pass

func open() :
	$Tween.interpolate_property(self, "modulate", modulate, Color(r,g,b,.25), .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()
	$"StaticBody2D/CollisionShape2D".disabled = true
	
func close() : 
	$Tween.interpolate_property(self, "modulate", modulate, Color(r,g,b,1), .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()
	$"StaticBody2D/CollisionShape2D".disabled = false
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
