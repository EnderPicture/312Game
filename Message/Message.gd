extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var up = false
onready var text_box = $"MessageRoot/MessageText"
onready var world = $"/root/World"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_just_pressed("exitMessage") && !text_box.animating:
		close_text()
	
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func show_text(text):
	
	text_box.set_text(text)
	$Tween.interpolate_property(self, "offset", offset, Vector2(0,0), .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()
	up = true
	$"/root/World".message_up = up
	
func close_text():
	if up :
		if text_box.done :
			$Tween.interpolate_property(self, "offset", offset, Vector2(0,200), .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
			$Tween.start()
			up = false
			$"/root/World".message_up = up
			
			if "I have all five pieces now." in text_box.pending_text :
				world.phone.end_l1()
		else :
			text_box.next_section()