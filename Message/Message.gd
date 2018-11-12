extends CanvasLayer

onready var pic1 = $"pics/pic-1"
onready var pic2 = $"pics/pic-2"
onready var pic3 = $"pics/pic-3"
onready var pic4 = $"pics/pic-4"
onready var pic5 = $"pics/pic-5"

var good_end = [
	"What the hell?",
	"Where is he? You told me he’d be here.",
	"What? There’s no call history. ",
	"...",
	"There is no kidnapper.",
	"Kyle isn’t here. He was never here. He’s at Parkgate cemetery, where he’s been since last February.",
	"He died in that car crash. I was driving. I just looked in my rear view for a second- and then it all happened, and he was gone.",
	"None of this was real. I set all this up myself – I was the kidnapper. I wanted to bring Kyle back, I wanted to save him. But I can’t. He’s gone and I can’t save him.",
	"Goodbye, Kyle. I won’t see you again.",
	"Fade out."
]

var bad_end = [
	"The mother: Kyle!",
	"I took Kyle home.",
	"Out of fear, I never told anyone about the incident.",
	"But true to his word, I haven’t heard anything from the kidnapper.",
	"Kyle doesn’t seem bothered by the incident.",
	"His teachers haven’t contacted me, so I can only assume he’s doing fine at school.",
	"I can’t shake the feeling that I’m missing something.",
	"All the work to put that together- and for what?",
	"I don’t know what the kidnapper had planned.",
	"But I’m just glad I have my son back.",
	"Kyle",
	"2010 - 2017",
	"Came in full of joy and left too early. Know you were loved and will be missed."
]

var up = false
onready var text_box = $"MessageRoot/MessageText"
onready var world = $"/root/World"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	close_pic(true)
	pass

func _process(delta):
	if Input.is_action_just_pressed("exitMessage") && !text_box.animating:
		close_text()
	
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func show_pic() :
	$Tween.interpolate_method(self, "set_pic_opacity", $pics.modulate.a, 1, .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()

func close_pic(instant = false) :
	if instant :
		set_pic_opacity(0)
	$Tween.interpolate_method(self, "set_pic_opacity", $pics.modulate.a, 0, .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()

func set_pic_opacity(a) :
	$pics.modulate = Color(1,1,1,a)
	
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
			close_pic()
			up = false
			$"/root/World".message_up = up
			
			if "I have all five pieces now." in text_box.pending_text :
				world.phone.end_l1()
			if "Three of the three" in text_box.pending_text :
				world.phone.end_l3() 
			
			if text_box.pending_text == good_end[0] :
				show_text(good_end[1])
			elif text_box.pending_text == good_end[1] :
				show_text(good_end[2])
			elif text_box.pending_text == good_end[2] :
				show_text(good_end[3])
			elif text_box.pending_text == good_end[3] :
				show_text(good_end[4])
			elif text_box.pending_text == good_end[4] :
				show_text(good_end[5])
			elif text_box.pending_text == good_end[5] :
				show_text(good_end[6])
			elif text_box.pending_text == good_end[6] :
				show_text(good_end[7])
			elif text_box.pending_text == good_end[7] :
				show_text(good_end[8])
			elif text_box.pending_text == good_end[8] :
				show_text(good_end[9])
				
			if text_box.pending_text == bad_end[0] :
				show_text(bad_end[1])
			elif text_box.pending_text == bad_end[1] :
				show_text(bad_end[2])
			elif text_box.pending_text == bad_end[2] :
				show_text(bad_end[3])
			elif text_box.pending_text == bad_end[3] :
				show_text(bad_end[4])
			elif text_box.pending_text == bad_end[4] :
				show_text(bad_end[5])
			elif text_box.pending_text == bad_end[5] :
				show_text(bad_end[6])
			elif text_box.pending_text == bad_end[6] :
				show_text(bad_end[7])
			elif text_box.pending_text == bad_end[7] :
				show_text(bad_end[8])
			elif text_box.pending_text == bad_end[8] :
				show_text(bad_end[9])
			elif text_box.pending_text == bad_end[9] :
				show_text(bad_end[10])
			elif text_box.pending_text == bad_end[10] :
				show_text(bad_end[11])
			elif text_box.pending_text == bad_end[11] :
				show_text(bad_end[12])
			
			if text_box.pending_text == "Thank you, Doctor. I'll try to keep that in mind if the grief becomes too overwhelming." :
				show_text("I’ll need to grab Kyle before I leave.")
				
			
		else :
			text_box.next_section()