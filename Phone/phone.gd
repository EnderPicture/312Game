extends CanvasLayer

var level = 0

onready var world = $"/root/World"


var win = "When I... lost someone. Someone very close to me."
var lie = [
	"When my husband left me and Kyle",
	"When I was laid off from my job.",
	"When I was broke and couldn't provide for myself and Kyle.",
	"When I was a child and my parents fought all the time"
]
var lie_removed = [
	false,
	false,
	false,
	false
]
var ignore = "I change my mind, I want to look around more."

var deny = "That is the truth. What do you want from me? I answered your question, let me through." 
var deny2 = "Please! I’m telling the truth. Open the door, let me see Kyle!"

var options = []

var text_hello = "Hello?"
var text_ok = "Ok..."
var dismiss = "Dismiss"

var l1convo_part1 = "Yes, it’s a photo of me and Kyle."
var l1convo_part2 = "How did you get this? Why are you doing this?"

var l2convo_part1 = "Is this… Did you copy my house?"
var l2convo_part2 = "How do you know what it looks like!?"

var nap_lie_text = "Why are you lying to me? Tell the truth."

var l3convo_part1 = "Of course it is- don’t even ask."
var l3convo_part2 = "The truth is you stole my child."
var l3convo_part3 = "I did what you asked, now let me see him."


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

var should_reset = true

var lie_once = false
var deny_once = false

export var shake = false

var start_convo = [
	"Hello?",
	"What? Who is this?",
	"Okay, okay. I understand. I’ll do what you say."
]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	hidden(true)
	pass
	
func prestart() :
	level = 0
	ye_button.show()
	no_button.hide()
	ye_button_lable.text = start_convo[0]
	nap_text.text = ""
	up()
	

func start_l1() :
	level = 1
	
	down()
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

func entered_l2() :
	level = 2
	nap_text.text = ""
	ye_button_lable.text = l2convo_part1
	up()

func question_l2() :
	if !should_reset :
		return
	
	no_button.hide()
	ye_button_lable.text = dismiss
	nap_text.text = " I want you to tell me about the hardest time in your life. Take your time- reminisce, think about it. Call me when you have your answer."

func end_l2() :
	if !should_reset :
		return
	
	ye_button.show()
	no_button.show()
	
	if !lie_once:
		ye_button_lable.text = "Yes"
		nap_text.text = "Are you ready to answer my questions?"
	else :
		ye_button_lable.text = "tell the truth."
		if !deny_once :
			nap_text.text = nap_lie_text
		else : 
			nap_text.text = "I know when you’re lying. Stop it, just tell the truth."
	
	no_button_lable.text = "No"
	
	
	reset_bottom_buttons()
	up()
	
func entered_l3() :
	level = 3
	nap_text.text = "This is the final room. I’ve hidden 3 keys, you’ll need all of them to unlock the last door. After that, you’ll never hear from me again. I just hope you find what you’re looking for..."
	ye_button.show()
	ye_button_lable.text = dismiss
	no_button.hide()
	down()
	start_shake()
	
func end_l3() :
	nap_text.text =  "Are you sure this is what you want?"
	ye_button_lable.text = l3convo_part1
	down()
	start_shake()

func clear_phone() :
	nap_text.text = ""
	ye_button_lable.text = dismiss
	down()
	

func reset_bottom_buttons():
	
	options.clear()
	options.append(ignore)
	if world.l2_p1:
		options.append(win)
	if world.l2_p2 && !lie_removed[0]:
		options.append(lie[0])
	if world.l2_p3 && !lie_removed[1]:
		options.append(lie[1])
	if world.l2_p4 && !lie_removed[2]:
		options.append(lie[2])
	if world.l2_p5 && !lie_removed[3]:
		options.append(lie[3])
	
	if lie_once :
		if deny_once :
			options.append(deny2)
		else :
			options.append(deny)
		
	for i in range(len(options)) :
		labels[i].text = options[i]
		buttons[i].show()
	
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
	
	$"ShakeCon/PhoneScreen/ScrollHandle".show_top()
	
	if options[index] == lie[0] :
		lie_removed[0] = true
		lie_once = true
		ye_button_lable.text = "tell the truth."
		nap_text.text = nap_lie_text
	if options[index] == lie[1] :
		lie_removed[1] = true
		lie_once = true
		ye_button_lable.text = "tell the truth."
		nap_text.text = nap_lie_text
	if options[index] == lie[2] :
		lie_removed[2] = true
		lie_once = true
		ye_button_lable.text = "tell the truth."
		nap_text.text = nap_lie_text
	if options[index] == lie[3] :
		lie_removed[3] = true
		lie_once = true
		ye_button_lable.text = "tell the truth."
		nap_text.text = nap_lie_text
	
	if options[index] == deny :
		nap_text.text = "I know when you’re lying. Stop it, just tell the truth."
		ye_button_lable.text = "tell the truth."
		deny_once = true
		
	elif options[index] == win :
		nap_text.text = "Good. I’m glad you were able to admit the truth. The door is unlocked, go through."
		world.l2_clue += 1
		ye_button_lable.text = dismiss
		no_button.hide()
		should_reset = false
		world.doorl3_1.open()
		world.doorl3_2.open()
		world.doorl3_3.open()
		pass
	
	elif options[index] == deny2 :
		nap_text.text = "You insist on lying. Fine, I’ll open the door- but I expected more from you. You should be able to accept the truth. The door is unlocked, go through."
		ye_button_lable.text = dismiss
		no_button.hide()
		should_reset = false
		world.doorl3_1.open()
		world.doorl3_2.open()
		world.doorl3_3.open()
		pass
	
	elif options[index] == ignore :
		down()
		if should_reset:
			question_l2()

func _on_Yes_pressed():
	
	
	
	if ye_button_lable.text == dismiss :
		down()
		return
	
	if level == 0:
		if ye_button_lable.text == start_convo[0] :
			ye_button_lable.text = start_convo[1]
			nap_text.text = "I have your son."
		elif ye_button_lable.text == start_convo[1] :
			ye_button_lable.text = start_convo[2]
			nap_text.text = "It doesn’t matter who I am- what’s important is I have Kyle, and you have to come get him.\n\n\nI’m going to send you an address. Drive here – alone – and don’t call the cops. Do as I say, or you’ll never see him again."
		elif ye_button_lable.text == start_convo[2]:
			world.black()
			down()

	elif level == 1 : 
		if ye_button_lable.text == text_hello :
			nap_text.text = "Go inside"
			ye_button_lable.text = text_ok
		elif ye_button_lable.text == text_ok :
			world.doorl1_1.open()
			world.doorl1_2.open()
			hidden()
		elif ye_button_lable.text == l1convo_part1 : 
			ye_button_lable.text = l1convo_part2
		elif ye_button_lable.text == l1convo_part2 :
			ye_button_lable.text = dismiss
			nap_text.text = "That’s for you to figure out. The door is unlocked. Go through it."
			world.doorl2_1.open()
	elif level == 2 :
		if ye_button_lable.text == l2convo_part1:
			ye_button_lable.text = l2convo_part2
		elif ye_button_lable.text == l2convo_part2:
			ye_button_lable.text = dismiss
			nap_text.text = " I want you to tell me about the hardest time in your life. Take your time- reminisce, think about it. Call me when you have your answer."
		elif ye_button_lable.text == "tell the truth." || ye_button_lable.text == "Yes":
			reset_bottom_buttons()
			$"ShakeCon/PhoneScreen/ScrollHandle".show_bottom()
	elif level == 3 :
		if ye_button_lable.text == l3convo_part1 :
			ye_button_lable.text = l3convo_part2
			nap_text.text = "I just worry you can’t accept the truth."
		elif ye_button_lable.text == l3convo_part2 :
			ye_button_lable.text = l3convo_part3
		elif ye_button_lable.text == l3convo_part3 :
			world.doorl3_locked1_1.open()
			world.doorl3_locked1_2.open()
			nap_text.text = "The door is already open"
			ye_button_lable.text = dismiss



func _on_No_pressed():
	down()
	if should_reset :
		question_l2()
	
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
