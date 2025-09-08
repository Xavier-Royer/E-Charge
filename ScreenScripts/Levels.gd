extends Node2D
signal level_completed
signal trans_done 
var level
var screen_size= OS.get_screen_size()
var playing = false
signal level_lost
var hints = [
	["Use down arrow to switch players",'down'],
	["Use space on the station to transfer engergy",'station_used'],
	["Ultra speed boosts propel the player unit they hit an object",'time'],
	["Chargers increase your engery when another player moves",'charger'],
	["Ultra speed boosts can be stopped by ANY object",'time'],
	["Buttons stay in there state once hit, unlike pressure plates",'time'],
	["Make sure to count the correct amount to give the first time",'time'],
	["Remember ALWAYS prioritize charging",'time'],
	["Speed boosts can tthe reduce the amount of moves",'time'],
	["Take it one step at a time",'time'],
	["Chargers can be used by multiple players",'time'],
	["Spread the energy to everyone",'time'],
	["Make sure to have enough engery before leaving",'time'],
	["If only the car stopped at the pressure plate...",'time'],
	["Congrats for making it this far! Write fully charged in the comments",'time']
	]

var hint_used
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	if int("Tween") != 0:
		print('not zero')
		print(int('Twee '))
	else:
		print("isZEor")
	for i in self.get_children():
		if int(i.name)  !=0:
			i.connect('level_complete',self,'level_complted')
			i.connect('lost',self,'level_lost')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_levels(l):
	level = l
	for i in self.get_children():
		if int(i.name) !=0:
			
			if int(i.name) == level:
				i.level_number = level
				i.setup()
				i.show()
				hint_used = false
				if len(hints) >level-1:
					$HBoxContainer/Hint.set_text(hints[level-1][0])
					if level == Settings.get_level_on():
						$HBoxContainer.show()
						$Hint.hide()
						i.connect(hints[level-1][1],self,"hide_hint")
					else:
						hint_used = true
						$Hint.show()
						$Hint.set_modulate(Color(1,1,1,1))
						$HBoxContainer.hide()
				else:
					$Hint.hide()
					$HBoxContainer.hide()
					
			else:
				i.level_number = level
				
				i.setup()
				i.hide()
	


func level_complted():
	stop_play()
	self.set_modulate(Color(0.5,0.5,0.5,1))
	emit_signal('level_completed')

func next_level():
	var n = self.get_node(str(level))
	var t = Tween.new()
	t.name = "Tween"
	add_child(t)
	var offset_x  = n.position.x
	t.interpolate_property(n,'position',Vector2(offset_x,0),Vector2(screen_size.x+offset_x,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
	t.start()
	n = self.get_node(str(level+1))
	offset_x = n.position.x
	hint_used = false
	if len(hints) >level-1:
		$HBoxContainer/Hint.set_text(hints[level-1][0])
		if level == Settings.get_level_on():
			$HBoxContainer.show()
			$Hint.hide()
			n.connect(hints[level-1][1],self,"hide_hint")
		else:
			hint_used = true
			$Hint.show()
			$Hint.set_modulate(Color(1,1,1,1))
			$HBoxContainer.hide()
	else:
		$Hint.hide()
		$HBoxContainer.hide()
	
	
	
	
	print("OFFSET")
	print(offset_x)
	print(Vector2(screen_size.x+offset_x,0))
	n.set_position(Vector2(screen_size.x+offset_x,0))
	yield(t,"tween_all_completed")
	set_levels(level+1)
	
	t.interpolate_property(n,'position',Vector2(screen_size.x+offset_x,0),Vector2(offset_x,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
	t.start()
	n.show()
	yield(t,"tween_all_completed") 
	emit_signal("trans_done")
	t.queue_free()

func start_play():
	for i in self.get_children():
		if int(i.name) !=0:
			i.start_play()

func stop_play():
	for i in self.get_children():
		if int(i.name) !=0:
			i.stop_play()

func level_lost():
	stop_play()
	self.set_modulate(Color(0.5,0.5,0.5,1))
	emit_signal('level_lost')

func hide_hint():
	if hint_used == false:
		hint_used = true
		var t = Tween.new()
		t.interpolate_property($Hint,'modulate',Color(1,1,1,0),Color(1,1,1,1),1,Tween.TRANS_BACK,Tween.EASE_IN)
		t.interpolate_property($HBoxContainer,'modulate',Color(0,0,0,1),Color(0,0,0,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		t.set_name("billy")
		add_child(t)
		t.start()
		
		$Hint.show()
		yield(t,"tween_all_completed")
		
		t.queue_free()


func _on_Hint_pressed():
	get_parent().get_node("Click").play()
	$Hint.release_focus()
	if hint_used:
		hint_used = false
		$HBoxContainer.show()
		var t = Tween.new()
		t.interpolate_property($HBoxContainer,'modulate',Color(0,0,0,0),Color(0,0,0,1),1,Tween.TRANS_BACK,Tween.EASE_IN)
		t.set_name("billy")
		add_child(t)
		t.start()
		yield(t,"tween_all_completed")
		t.queue_free()
	else:
		hint_used = true
		$HBoxContainer.show()
		var t = Tween.new()
		t.interpolate_property($HBoxContainer,'modulate',Color(0,0,0,1),Color(0,0,0,0),1,Tween.TRANS_BACK,Tween.EASE_IN)
		t.set_name("billy")
		add_child(t)
		t.start()
		yield(t,"tween_all_completed")
		t.queue_free()
