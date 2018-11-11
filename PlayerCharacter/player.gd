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

var photo_pieces = 4
var c01 = 0
var p02 = 0
var c02 = 0
var p03 = 0
var c03 = 0

var max_photo_pieces = 1

var ray_length = 15

var last_unix_time = -1

var level = 0

var Interaction_pointL2 = [
	"I pull the fridge open, but there’s nothing inside.",
	"I open the drawer, but there’s nothing inside.",
	"I normally put letters, bills, and notices from Sam’s school on the island at home- but there’s nothing on this one.",
	"I turn the taps- nothing comes out.",
	"I open the dresser, but it’s empty.",
	"I check on top and below the nightstand, but there’s nothing here.",
	"I pull open the dresser, scared I’d find old clothes I’d thrown away. I breathe a sigh of relief when it’s empty.",
	"I test the bed with my hand. It’s rock hard. I lift up the sheets to find its just plywood with the bed spread thrown over top. I let the sheets fall back in to place.",
	"I run my hand along the stove. It’s not the exact same as mine, but it reminds me of cooking for Sam anyways."]

	
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
			level = 2
			last_unix_time = OS.get_unix_time()
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
						
				elif parrent_collider.type == "clue1-1" :
					world.message.show_text("There’s a photo frame here. Is it the one the photo pieces are from? I pick it up and freeze. This is my photo frame, I recognize it. The kidnapper had broken it in and stolen it. How long has he been following us?")
				elif parrent_collider.type == "clue1-2" :
					world.message.show_text("There’s a stuffed animal here, clearly well loved. One of the ears is partly ripped off and he’s missing an eye- but he still looks charming. Kyle had one just like it when he was young- but how did it get here?")
				elif parrent_collider.type == "clue1-3" :
					world.message.show_text("There’s a baby crib in here. My baby crib. I’d put it in storage when Kyle grew out of it. The kidnapper stole it and brought it all the way here- but why? Did he want me to find it? I shudder, not wanting to think about it.")
				elif parrent_collider.type == "" :
					world.message.show_text("There’s nothing in here. I kick it out of the way in frustration.")
				
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
	
	if motion.length() == 0:
		$"Sprite/AnimationPlayer".stop()
	
	motion = motion.normalized() * MOTION_SPEED

	move_and_slide(motion)


func _delete_object(collider) :
	collider.get_parent().remove_child(collider)

