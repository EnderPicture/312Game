extends CanvasLayer

var level = 0

onready var world = $"/root/World"

var lie = [
    "When my husband left me and Kyle",
    "When I was laid off from my job.",
    "When I was a child and my parents fought all the time",
    "When I was broke and couldn't provide for myself and Kyle."
]

var win = "When I... lost someone. Someone very close to me."
var deny = "That is the truth. What do you want from me? I answered your question, let me through." 
var ignore = "I change my mind, I want to look around more."

var options = [
	ignore,
	lie[0],
	win,
	lie[1],
	lie[2],
	lie[3]
]

var text_hello = "Hello?"
var text_ok = "Ok..."
var dismiss = "Dismiss"

var l1convo_part1 = "Yes, it’s a photo of me and Kyle."
var l1convo_part2 = "How did you get this? Why are you doing this?"

onready var buttons = [
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button1,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button2,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button3,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button4,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button5,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button6
]

onready var labels = [
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button1/Label,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button2/Label,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button3/Label,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button4/Label,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button5/Label,
    $ShakeCon/PhoneScreen/ScrollHandle/Bottom/Button6/Label
]

onready var ye_button = $ShakeCon/PhoneScreen/ScrollHandle/Top/Yes
onready var ye_button_lable = $ShakeCon/PhoneScreen/ScrollHandle/Top/Yes/Label
onready var no_button = $ShakeCon/PhoneScreen/ScrollHandle/Top/No
onready var no_button_lable = $ShakeCon/PhoneScreen/ScrollHandle/Top/No/Label

onready var nap_text = $ShakeCon/PhoneScreen/ScrollHandle/Top/Kidnapper/text

var lie_once = false

export var shake = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	start_l1()

func start_l1() :
	level = 1
	
	down(true)
	ye_button.show()
	no_button.hide()
	
	ye_button_lable.text = text_hello
	nap_text.text = ""
	
	start_shake()

func entered_l1() :
	nap_text.text = "There’s a photo in here, torn in to five different pieces. Find all the pieces, and put the photo back together. Once you tell me what the photo is of, I’ll open the next door for you."
	ye_button_lable.text = dismiss
	down()
	start_shake()

func end_l1() :
	nap_text.text = "Did you finish it?"
	ye_button_lable.text = l1convo_part1
	end_shake()
	up()

func start_l2() :
	level = 2
	options = [
		ignore,
		lie[0],
		win,
		lie[1],
		lie[2],
		lie[3]
	]
	ye_button.show()
	no_button.show()
	
	ye_button_lable.text = "Yes"
	no_button_lable.text = "No"
	
	$"PhoneScreen/ScrollHandle/Top/Kidnapper/text".text = "Are you ready to answer my questions?"
	reset_bottom_buttons()

func reset_bottom_buttons():
	for i in range(len(options)) :
		labels[i].text = options[i]
	
	for i in range(len(labels)-len(options)) :
		buttons[len(labels)-1-i].hide()

func start_shake() :
	$AnimationPlayer.current_animation = "PhoneShake" 

func end_shake() :
	$AnimationPlayer.current_animation = ""
	shake = false
	

func _process(delta):
	if shake:
		shake()
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _bottom_button_pressed(index):
	
	$"PhoneScreen/ScrollHandle".show_top()
	
	# if selected lie
	var selectedlie = -1
	for i in len(lie) :
		if options[index] == lie[i] :
			selectedlie = i
			break
	
	if selectedlie != -1:
		options.erase(lie[selectedlie])
		if !lie_once:
			options.append(deny)
			lie_once = true
	
	elif options[index] == win :
		pass
	
	elif options[index] == deny :
		pass
	
	elif options[index] == ignore :
		down()

func _on_Yes_pressed():
	if level == 1 : 
		if ye_button_lable.text == text_hello :
			nap_text.text = "Go inside"
			ye_button_lable.text = text_ok
		elif ye_button_lable.text == text_ok :
			world.doorl1_1.open()
			world.doorl1_2.open()
			hidden()
		elif ye_button_lable.text == dismiss :
			down()
		elif ye_button_lable.text == l1convo_part1 : 
			ye_button_lable.text = l1convo_part2
		elif ye_button_lable.text == l1convo_part2 :
			ye_button_lable.text = dismiss
			nap_text.text = "That’s for you to figure out. The door is unlocked. Go through it."
			world.doorl2_1.open()
	elif level == 2 :
		reset_bottom_buttons()
		$"PhoneScreen/ScrollHandle".show_bottom()



func _on_No_pressed():
	down()
	
func up(instant = false):
	if instant :
		offset = Vector2(0,0)
		return

	$Tween.interpolate_property(
		self,
		"offset",
		offset,
		Vector2(0,0),
		.5, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0)
	$Tween.start()
	world.phone_up = true

func down(instant = false):
	
	var off_from_bottom = 120
	var height = get_tree().root.get_visible_rect().size.y
	
	if instant :
		offset = Vector2(0,height-off_from_bottom)
		return

	
	$Tween.interpolate_property(
		self,
		"offset",
		offset,
		Vector2(0,height-off_from_bottom),
		.5, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0)
	$Tween.start()
	world.phone_up = false

func hidden(instant = false):
	var height = get_tree().root.get_visible_rect().size.y
	
	if instant :
		offset = Vector2(0,height)
		return
	
	$Tween.interpolate_property(
		self,
		"offset",
		offset,
		Vector2(0,height),
		.5, 
		Tween.TRANS_QUAD,
		Tween.EASE_OUT,
		0)
	$Tween.start()
	world.phone_up = false
	

func _on_Button1_pressed():
	_bottom_button_pressed(0)

func _on_Button2_pressed():
	_bottom_button_pressed(1)

func _on_Button3_pressed():
	_bottom_button_pressed(2)
	
func _on_Button4_pressed():
	_bottom_button_pressed(3)

func _on_Button5_pressed():
	_bottom_button_pressed(4)

func _on_Button6_pressed():
	_bottom_button_pressed(5)


func _on_up_pressed():
	end_shake()
	up()
	
func shake() :
	var shake_amount = 5
	$ShakeCon.rect_position = Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount)
