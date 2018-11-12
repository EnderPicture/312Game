extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

# Member variables
const MOTION_SPEED = 80 # Pixels/second

onready var world = $"/root/World"

var hintsl1 = [
	"I should make sure to check every crate and barrel so I don’t miss anything.",
	"There are some crates hidden in the corners- I should check those ones.",
	"Some of these crates are stuck behind the ones in front of them. I should check those ones too."]
var hintsl1_index = 0
var hintsl2 = [
	"There’s a lot of memories in here. I should take my time to look at everything.",
	"There’s a few rooms down the hall from the kitchen- maybe I missed something in there?",
	"There’s a lot of drawers in the kitchen. If I’m lucky, I might be able to find something useful in there."]
var hintsl2_index = 0

var photo_pieces = 0
var l3_puz_pieces = 0

var l3_key = false

var max_photo_pieces = 1

var ray_length = 15

var last_unix_time = -1

var level = 0

var Interaction_pointL2 = [
	"I pull the fridge open, but there’s nothing inside.",
	"I open the drawer, but there’s nothing inside.",
	"I normally put letters, bills, and notices from Kyle’s school on the island at home- but there’s nothing on this one.",
	"I turn the taps- nothing comes out.",
	"I open the dresser, but it’s empty.",
	"I check on top and below the nightstand, but there’s nothing here.",
	"I pull open the dresser, scared I’d find old clothes I’d thrown away. I breathe a sigh of relief when it’s empty.",
	"I test the bed with my hand. It’s rock hard. I lift up the sheets to find its just plywood with the bed spread thrown over top. I let the sheets fall back in to place.",
	"I run my hand along the stove. It’s not the exact same as mine, but it reminds me of cooking for Kyle anyways."]
var clueL2 = [
	"There’s a pile of invoices here. I recognize them immediately- they’re mine, for my therapy. I keep them so I can apply for my insurance reimbursement later- but the kidnapper has taken them too. I knock them off the counter in anger. He’s violated the sanctity of my home, he’s throwing my own life in my face, and he took Kyle. I need to finish this.",
	"There’s a pile of newspapers here. I skim them quickly- all the dates are for February of last year. The older ones share the same cover story – a fatal crash on the highway. As the papers get newer, the crash is featured less on less until it disappears off the cover entirely. I drop the newspapers back into a pile."
]
var screwdriver = false
var screwdriver_message = "I open the drawer and find a screwdriver. It’s sturdy, and looks like it could be useful later. I pick it up."

var puzzleL2 = [
	"This is where my husband – Kyle’s dad – told me he wanted to get a divorce. I didn’t see it coming, I was still so in love. He told me this life isn’t what he wanted and he’d made a mistake. Once he moved out, I never saw him again. The divorce papers arrived in the mail. I hope he’s happier, wherever he is.",
	"There’s a letter of termination here. I’d gotten laid off from my job years ago, when Kyle was still a baby. The company had fallen on hard times, and I wasn’t deemed valuable enough to remain. It’s the only time I’ve ever left a job against my will.",
	"A stack of overdue bills sits here. After Kyle’s dad left, I had trouble paying for everything on my own. Money was tight for a while, I had to do some pretty desperate things to cut costs. I was eventually able to get a pay raise and things got easier, but that was one of the lowest points of my life.",
	"My parents fought a lot when I was a kid. It was always something- mom’s spending habits, dad’s drinking, how to raise me. I used to wake up to the sound of them screaming in the other room. I vowed to give Kyle a better childhood. I hope I’m doing right by him."
]

func raycast(motion) :
	if motion.length() != 0 :
		$RayCast2D.cast_to = motion.normalized() * ray_length
	if $RayCast2D.is_colliding() :
		return $RayCast2D.get_collider()
	return null

func _ready():
	$RayCast2D.add_exception($"Area2D")

func _physics_process(delta):
	var motion = Vector2()
	
	if last_unix_time != -1 && OS.get_unix_time() - last_unix_time > 30 :
		if level == 1 :
			world.message.show_text(hintsl1[hintsl1_index])
			last_unix_time = OS.get_unix_time()
			if hintsl1_index < len(hintsl1)-1 :
				hintsl1_index += 1
		if level == 2 :
			world.message.show_text(hintsl2[hintsl2_index])
			last_unix_time = OS.get_unix_time()
			if hintsl2_index < len(hintsl2)-1 :
				hintsl2_index += 1
		
	
	for collider in $Area2D.get_overlapping_areas() :
		if collider.get_name() == "enteredL1" :
			world.doorl1_1.close()
			world.doorl1_2.close()
			world.phone.entered_l1()
			level = 1
			last_unix_time = OS.get_unix_time()
			collider.queue_free()
		elif collider.get_name() == "enteredL2" :
			world.doorl2_1.close()
			world.phone.entered_l2()
			level = 2
			last_unix_time = OS.get_unix_time()
			collider.queue_free()
		elif collider.get_name() == "enteredL3" :
			world.doorl3_1.close()
			world.doorl3_2.close()
			world.doorl3_3.close()
			world.phone.entered_l3()
			level = 3
			last_unix_time = -1
			$"Light2D2".enabled = true
			world.dim_lights()
			
			$Tween.interpolate_method(self, "light", $Light2D.energy, 2.5, 5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
			$Tween.start()
			$Tween.interpolate_method(self, "light_shadow", $Light2D2.energy, 2, 5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
			$Tween.start()
			
			collider.queue_free()
			
		elif collider.get_name() == "ENDING" :
			if world.l1_clue + world.l2_clue + world.l3_clue >= 5 :
				world.message.show_text(world.message.good_end[0])
			else :
				world.message.show_text(world.message.bad_end[0])
			world.phone.clear_phone()
			world.doorl3_locked1_1.close()
			world.doorl3_locked1_2.close()
			collider.queue_free()
		elif collider.get_name() == "L0_teleport" :
			world.phone.prestart()
			collider.queue_free()
			
	
	if !world.message_up && !world.phone_up:
		if Input.is_action_pressed("up"):
			motion += Vector2(0, -1)
			$"Sprite/AnimationPlayer".current_animation = "walkU"
		elif Input.is_action_pressed("down"):
			motion += Vector2(0, 1)
			$"Sprite/AnimationPlayer".current_animation = "walkD"
		elif Input.is_action_pressed("left"):
			motion += Vector2(-1, 0)
			$"Sprite/AnimationPlayer".current_animation = "walkL"
		elif Input.is_action_pressed("right"):
			motion += Vector2(1, 0)
			$"Sprite/AnimationPlayer".current_animation = "walkR"
		
		var collider = raycast(motion)
		
		if Input.is_action_just_pressed("enter") && collider != null :
			
			#reset timer for hint, they know what they are doing
			last_unix_time = OS.get_unix_time()
			
			var parrent_collider = collider.get_parent()
			if parrent_collider.has_method("react") :
				parrent_collider.react()
			if "type" in parrent_collider :
				
				if "photop" in parrent_collider.type :
					photo_pieces += 1
					world.sound.play()
					if photo_pieces == 1 :
						world.message.show_text("One of the five pieces of the photo, the edges ragged from where it’s been torn. It looks familiar, but I can’t tell what the picture is of yet. I pick it up.")
					elif photo_pieces == 2 :
						world.message.show_text("The second of the five photo pieces, the edges ragged from where it’s been torn. It looks familiar, but I can’t tell what the picture is of yet. I pick it up.")
					elif photo_pieces == 3 :
						world.message.show_text("The third of the five photo pieces, the edges ragged from where it’s been torn. It looks familiar, but I can’t tell what the picture is of yet. I pick it up.")
					elif photo_pieces == 4 :
						world.message.show_text("The fourth of the five photo pieces, the edges ragged from where it’s been torn. It looks familiar, but I can’t tell what the picture is of yet. I pick it up.")
					elif photo_pieces == 5 :
						world.message.show_text("The final piece of the photo, the edges ragged from where it’s been torn. I have all five pieces now. I pull them out and arrange them around until I’ve reassembled the photo. I gasp, both in shock and rage. It’s a photo of me and Kyle from early last year.")
				
					if parrent_collider.type == "photop1" :
						world.message.pic1.visible = true
						world.message.show_pic()
					if parrent_collider.type == "photop2" :
						world.message.pic2.visible = true
						world.message.show_pic()
					if parrent_collider.type == "photop3" :
						world.message.pic3.visible = true
						world.message.show_pic()
					if parrent_collider.type == "photop4" :
						world.message.pic4.visible = true
						world.message.show_pic()
					if parrent_collider.type == "photop5" :
						world.message.pic5.visible = true
						world.message.show_pic()
						
				
				elif parrent_collider.type == "clue1-1" :
					world.sound.play()
					world.message.show_text("There’s a photo frame here. Is it the one the photo pieces are from? I pick it up and freeze. This is my photo frame, I recognize it. The kidnapper had broken it in and stolen it. How long has he been following us?")
					world.l1_clue += 1
				elif parrent_collider.type == "clue1-2" :
					world.sound.play()
					world.message.show_text("There’s a stuffed animal here, clearly well loved. One of the ears is partly ripped off and he’s missing an eye- but he still looks charming. Kyle had one just like it when he was young- but how did it get here?")
					world.l1_clue += 1
				elif parrent_collider.type == "clue1-3" :
					world.sound.play()
					world.message.show_text("There’s a baby crib in here. My baby crib. I’d put it in storage when Kyle grew out of it. The kidnapper stole it and brought it all the way here- but why? Did he want me to find it? I shudder, not wanting to think about it.")
					world.l1_clue += 1
				elif parrent_collider.type == "" :
					world.sound.play()
					world.message.show_text("There’s nothing in here. I kick it out of the way in frustration.")
				
				elif "L3-puz" in parrent_collider.type :
					l3_puz_pieces += 1
					world.sound.play()
					if l3_puz_pieces == 1 :
						world.message.show_text("One of the three keys I need to get to Kyle. I pick it up.")
					if l3_puz_pieces == 2 :
						world.message.show_text("Two of the three keys I need to get to Kyle. I pick it up.")
					if l3_puz_pieces == 3 :
						world.message.show_text("Three of the three keys I need to get to Kyle. I pick it up.")
				
			if "Interaction_pointL2" in collider.get_name() :
				if "Interaction_pointL2-1" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[0])
				elif "Interaction_pointL2-2" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[1])
				elif "Interaction_pointL2-3" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[2])
				elif "Interaction_pointL2-4" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[3])
				elif "Interaction_pointL2-5" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[4])
				elif "Interaction_pointL2-6" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[5])
				elif "Interaction_pointL2-7" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[6])
				elif "Interaction_pointL2-8" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[7])
				elif "Interaction_pointL2-9" in collider.get_name() :
					world.message.show_text(Interaction_pointL2[8])
			elif "clueL2" in collider.get_name() :
				if collider.get_name() == "clueL2-1" :
					world.sound.play()
					world.message.show_text(clueL2[0])
					world.l2_clue += 1
					collider.queue_free()
				if collider.get_name() == "clueL2-2" :
					world.sound.play()
					world.message.show_text(clueL2[1])
					world.l2_clue += 1
					collider.queue_free()
			elif collider.get_name() == "screwdriverL2" :
				world.message.show_text(screwdriver_message)
				screwdriver = true
				collider.queue_free()
			elif collider.get_name() == "lockeddoorL2" :
				if screwdriver : 
					world.doorl2_puzzle.open()
					
					collider.queue_free()
					world.message.show_text("I use the butt of the screwdriver to crush the front of the panel inwards. Flipping it around, I use the flathead to pry open the destroyed panel and rip the wires out. The field drops- I can get in to the room.")
				else :
					world.message.show_text("There’s another field here blocking entry to the room. I glance around and see the control panel. If I had something sturdy, I might be able to smash the panel open and bring the field down.")
			elif collider.get_name() == "phonepromptL2" :
				world.phone.end_l2() 
			elif collider.get_name() == "puzzleL2-1-locked" :
				if screwdriver : 
					world.sound.play()
					world.message.show_text("There’s a stack of photo albums in here. There are ages written on the sides instead of years or dates. I trace my number down the stack until I reach the last one. I slam the closet closed and take a shuddering breath. They’re my albums of someone very close to me- someone I lost. A lump settles in my stomach- the kidnapper planted these here. He wanted me to have this reaction. I take a breath to regain my composure. I have to push forward, for Kyle.")
					world.l2_p1 = true
					collider.queue_free()
				else : 
					world.message.show_text("I try to pull the door open, but it remains firmly shut. I wiggle the door. There’s some give. Maybe if I had a tool to pry it open, I could see what’s inside.")
			elif collider.get_name() == "puzzleL2-2" :
				world.sound.play()
				world.l2_p2 = true
				world.message.show_text(puzzleL2[0])
				collider.queue_free()
			elif collider.get_name() == "puzzleL2-3" :
				world.sound.play()
				world.l2_p3 = true
				world.message.show_text(puzzleL2[1])
				collider.queue_free()
			elif collider.get_name() == "puzzleL2-4" :
				world.sound.play()
				world.l2_p4 = true
				world.message.show_text(puzzleL2[2])
				collider.queue_free()
			elif collider.get_name() == "puzzleL2-5" :
				world.sound.play()
				world.l2_p5 = true
				world.message.show_text(puzzleL2[3])
				collider.queue_free()
			
			elif collider.get_name() == "ClueL3-1" :
				world.sound.play()
				world.l3_clue += 1
				world.message.show_text("There’s an obituary here. Part of it is torn off, but the rest is still readable. “Came in full of joy and left too early. Know you were loved and will be missed.” I shudder. Why would the kidnapper keep something like this? I put it back, looking at it made me feel apprehensive.")
				collider.queue_free()
			elif collider.get_name() == "ClueL3-2" :
				if l3_key :
					world.sound.play()
					world.l3_clue += 1
					world.message.show_text("I slip the key in and turn it. The lock box smoothly pops open. This is an official police statement dated for February last year. It’s an interview with a driver involved in a crash. The officer made note that the driver was in a state of shock and kept asking about their passenger. Who would keep something like this? I put it back down. Thinking about it was giving me a headache.")
					collider.queue_free()
				else : 
					world.message.show_text("There’s a small locked box on the ground here. I try to open it, but it doesn’t budge. I wonder if the key is around here somewhre/")
			elif collider.get_name() == "ClueL3-3" :
				if l3_key :
					world.sound.play()
					world.l3_clue += 1
					world.message.show_text("I slip the key in and turn it. The lock box smoothly pops open. There’s a set of car keys here- my car keys. I sold my last car after it broke down. Why would the kidnapper put them here?")
					collider.queue_free()
				else : 
					world.message.show_text("There’s a small locked box on the ground here. I try to open it, but it doesn’t budge. I wonder if the key is around here somewhre/")
			elif collider.get_name() == "KeyL3" :
				world.sound.play()
				l3_key = true
				world.message.show_text("There’s an envelope on the floor. I pick it up and a small key and a string of numbers falls out. They might be useful, I take them both.")
				collider.queue_free()
			elif collider.get_name() == "lockeddoorL3-2" :
				if l3_key : 
					world.doorl3_locked2_1.open()
					world.message.show_text("I punch in the code and the key pad chirps and turns green. The door pops open, unlocked.")
					collider.queue_free()
				else : 
					world.message.show_text("I pull on the door, but it’s locked. I look around- a key pad next to the door blinks at me and asks for a pin number. If I can find one, I can get in here.")
			elif collider.get_name() == "lockeddoorL3-3" :
				world.message.show_text("The door is locked, but I know Kyle is behind it. I bang on the door and call his name, but can’t make out any response. I’ll have to solve the kidnapper’s puzzle before I can get it.")

	if motion.length() == 0:
		$"Sprite/AnimationPlayer".stop()
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)


func _delete_object(collider) :
	collider.get_parent().remove_child(collider)
	
func light_shadow(energy) :
	$"Light2D".energy = energy
func light(energy) :
	$"Light2D2".energy = energy

