extends Node2D
var number 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup(number):
	var color = Settings.player_numnber_info[number][0]
	var icon = Settings.player_numnber_info[number][1]
	var icon_color = Settings.player_numnber_info[number][2]
	$Color.set_self_modulate(color)
	$icon.set_self_modulate(icon_color)
	
	$icon4.set_self_modulate(icon_color)
	$icon2.set_self_modulate(icon_color)
	$icon3.set_self_modulate(icon_color)
	$icon.set_texture(load(icon))
	$icon2.set_texture(load(icon))
	$icon3.set_texture(load(icon))
	$icon4.set_texture(load(icon))
