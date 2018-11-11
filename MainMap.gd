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

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
