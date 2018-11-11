extends Label

var pending_text
var text_index = 0
var max_char_per = 200
var done = false
var char_show_speed = .025

var animating = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_text(new_text):
	text_index = 0
	done = false
	pending_text = new_text
	var new_index = max_char_per
	var text_section = pending_text.substr(text_index, new_index-text_index)
	
	#check for spaces
	if len(text_section) == max_char_per :
		new_index = text_section.find_last(" ")
	
	
	visible_characters = 0
	text = pending_text.substr(text_index, new_index-text_index)
	
	_animate()
	
	text_index = new_index
	
	check_if_done() 
	
func next_section() :
	if (!done) :
		var new_index = text_index + max_char_per
		
		var text_section = pending_text.substr(text_index, new_index-text_index)
	
		#check for spaces
		if len(text_section) == max_char_per :
			new_index = text_index+text_section.find_last(" ")
		
		visible_characters = 0
		text = pending_text.substr(text_index, new_index-text_index)
		
		_animate()

		text_index = new_index
		check_if_done() 

func check_if_done() :
	if (text_index > len(pending_text)) :
		done = true

func _animate() :
	animating = true
	$Tween.interpolate_property(self, "visible_characters", 0, len(text), len(text)*char_show_speed, Tween.TRANS_LINEAR,Tween.EASE_IN, 0)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	animating = false
