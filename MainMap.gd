extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var message_up = false
var phone_up = false

onready var message = $"UI/Message"
onready var phone = $"UI/phone"

onready var doorl1_1 = $"Walls/DoorL1-1"
onready var doorl1_2 = $"Walls/DoorL1-2"

onready var doorl2_1 = $"Walls/DoorL2-1"
onready var doorl2_puzzle = $"Walls/DoorL2-puzzle"

onready var doorl3_1 = $"Walls/DoorL3-1"
onready var doorl3_2 = $"Walls/DoorL3-2"
onready var doorl3_3 = $"Walls/DoorL3-3"

onready var doorl3_locked1_1 = $"Walls/DoorL3-locked1-1"
onready var doorl3_locked1_2 = $"Walls/DoorL3-locked1-2"

onready var doorl3_locked2_1 = $"Walls/DoorL3-locked2-1"

onready var env = $"WorldEnvironment"

onready var sound = $InteractionSound

onready var player = $Walls/Player

var l1_clue = 0
var l2_clue = 0
var l3_clue = 0

var l2_p1 = false
var l2_p2 = false
var l2_p3 = false
var l2_p4 = false
var l2_p5 = false

var teleported = false


func dim_lights() :
	
	$Tween.interpolate_method(self, "env_exposure", env.environment.tonemap_exposure, .01, .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()
	
func env_exposure(exposure) :
	env.environment.tonemap_exposure = exposure

func black() : 
	$Tween.interpolate_method(self, "env_exposure", env.environment.tonemap_exposure, 0, .5, Tween.TRANS_QUAD,Tween.EASE_OUT, 0)
	$Tween.start()

func normal() :
	$Tween.interpolate_method(self, "env_exposure", env.environment.tonemap_exposure, 1, 5, Tween.TRANS_QUAD,Tween.EASE_IN_OUT, 0)
	$Tween.start()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	message.show_text("Thank you, Doctor. I'll try to keep that in mind if the grief becomes too overwhelming.")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Tween_tween_completed(object, key):
	if !teleported :
		teleported = true
		player.position.x = -527.767029
		player.position.y = 236.451996
		phone.start_l1()
		normal()
		
