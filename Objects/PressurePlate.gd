extends Node2D
var up = preload("res://Tiles/PlateUp.png")
var down = preload("res://Tiles/PlateDown.png")
var plate_number
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pressed():
	$Plate.set_texture(down)

func released():
	$Plate.set_texture(up)

func set_state(state):
	if state  == 0:
		$Plate.set_texture(down)
	else:
		$Plate.set_texture(up)
