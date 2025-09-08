extends Node2D
var button_pressed = preload("res://Tiles/Button down.png")
var button_up = preload("res://Tiles/button.png")
var button_state= 0
var button_number
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func switch_state():
	if button_state == 0:
		button_state = 1
		$TextureRect.set_texture(button_pressed)
	else:
		button_state = 0
		$TextureRect.set_texture(button_up)
		
		
		
