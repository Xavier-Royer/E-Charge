extends Node2D

func unfocus():
	for i in $HBoxContainer.get_children():
		i.release_focus()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func lost():
	$HBoxContainer/Next.hide()
	$HBoxContainer/Play.hide()
	$Label.set_text("Level Lost")

func win():
	$HBoxContainer/Next.show()
	$HBoxContainer/Play.hide()
	$Label.set_text("Level Complete")

func pause():
	$HBoxContainer/Play.show()
	$HBoxContainer/Next.hide()
	$Label.set_text("Level Paused")
