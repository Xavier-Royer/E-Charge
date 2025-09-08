extends Node2D
var screen_size= OS.get_screen_size()
onready var current_screen = $Home
var levs_in_row = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#Settings.save_level(1)
	$Levels.connect('level_completed',self,'level_complete')
	$Levels.connect('level_lost',self,'level_lost')
	for b in get_tree().get_nodes_in_group('levelbuttons'):
		b.connect('pressed',self,'level_selected',[b])
	#$ScreenTrans.connect("tween_all_completed",self,'trans_done')
#	trans_in($Levels)
#	yield($ScreenTrans,"tween_all_completed")
#	trans_out($Levels)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func trans_in(screen):
	$ScreenTrans.interpolate_property(screen,'position',Vector2(0,-screen_size.y),Vector2(0,0),1.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$ScreenTrans.start()
	
func trans_out(screen):
	$ScreenTrans.interpolate_property(screen,'position',Vector2(0,0),Vector2(0,-screen_size.y),1.5,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$ScreenTrans.start()

func level_selected(button):
	$Click.play()
	var level_numb = levs_in_row*int(button.get_parent().name) +int(button.name)
	button.release_focus()
	trans_out($Home)
	$Levels.set_levels(level_numb)
	$Levels.set_modulate(Color(1,1,1,1))
	yield($ScreenTrans,"tween_all_completed")
	$Home.un_focus()
	trans_in($Levels)
	yield($ScreenTrans,"tween_all_completed")
	$Levels.start_play()


func level_complete():
	$LevelOver.win()
	trans_in($LevelOver)
	#$Levels.level
	if 1+int($Levels.level) >Settings.get_level_on():
		Settings.save_level(1+int($Levels.level))

func level_lost():
	$LevelOver.lost()
	trans_in($LevelOver)

func _on_Retry_pressed():
	$Click.play()
	$Levels.set_levels($Levels.level)
	trans_out($LevelOver)
	$LevelOver.unfocus()
	yield($ScreenTrans,"tween_all_completed")
	$Levels.set_levels($Levels.level)
	$Levels.set_modulate(Color(1,1,1,1))
	$Levels.start_play()
	


func _on_Home_pressed():
	$Click.play()
	$Home.set_levels()
	trans_out($Levels)
	trans_out($LevelOver)
	$LevelOver.unfocus()
	yield($ScreenTrans,"tween_all_completed")
	trans_in($Home)
	

func _on_Next_pressed():
	$Click.play()
	$Levels.next_level()
	$LevelOver.unfocus()
	yield($Levels,'trans_done')
	trans_out($LevelOver)
	yield($ScreenTrans,"tween_all_completed")
	$Levels.set_modulate(Color(1,1,1,1))
	$Levels.start_play()
	
	


func _on_Pause_pressed():
	$Click.play()
	$Levels.stop_play()
	$Levels.set_modulate(Color(.5,.5,.5,1))
	$LevelOver.pause()
	trans_in($LevelOver)


func _on_Play_pressed():
	$Click.play()
	$LevelOver.unfocus()
	trans_out($LevelOver)
	yield($ScreenTrans,"tween_all_completed")
	$Levels.start_play()
	$Levels.set_modulate(Color(1,1,1,1))
	#$Levels.start_play()
