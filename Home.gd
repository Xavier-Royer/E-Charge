extends Node2D
var levels_in_row = 5
var level_on = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	set_levels()



func set_levels():
	#Settings.save_level(1)
	
	level_on = Settings.get_level_on()
	
	#level_on = 999
	#Delete when done!!!!!
	var x = 0 
	print(level_on)
	for i in $VBoxContainer.get_children():
		
		var y = 0 
		for j in i.get_children():
			y+=1
			if x*levels_in_row + y <= level_on:
				j.set_disabled(false)
				j.get_node("Label").show()
				j.get_node("Label").set_text(str(x*levels_in_row + y))
				if x*levels_in_row + y <= level_on-1:
					j.set_self_modulate(Color(1,1,0,1))
				else:
					j.set_self_modulate(Color(1,1,1,1))
			else:
				j.set_self_modulate(Color(1,1,1,1))
				j.set_disabled(true)
				j.get_node("Label").hide()
		x+=1

func un_focus():
	for i in $VBoxContainer.get_children():
		for j in i.get_children():
			j.set_disabled(true)
