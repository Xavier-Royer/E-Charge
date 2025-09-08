extends KinematicBody2D
var level_on
var is_playing = false
var level_playing =false
var velocity =Vector2.ZERO
export var SPEED = Vector2(25,25)
export var FRICTION = Vector2(0.92,0.92)
var selected = false
var playing_level = false
onready var wall = get_parent().get_node("Walls")
onready var objects = get_parent().get_node("Objects")
onready var boosts = get_parent().get_node("Boosts")
onready var buttons = get_parent().get_node("Buttons")
onready var plates = get_parent().get_node("Plates")
onready var chargers = get_parent().get_node("Charger")
onready var finish = get_parent().get_node("Finish")
var move_finished = true
var tile_size = 40
var direction = Vector2(tile_size,0)
var cool_down = 0.1
var energy =10
signal give_electricity
signal selected
signal button_hit
signal plate_hit
signal moved
signal full_move_done
signal finished
var needs_release = false
var boost_slide = false
var slide_dir 
var plate_on
var on_plate = false
var charging = false
var turn_number = 0
var player_positions = []
var player_finsihed = false
var gate_positions = []
var sound_done = true
signal charged
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func reset():
	 needs_release = false
	 boost_slide = false
	 move_finished = true
	 on_plate = false
	 charging = false
	 turn_number = 0
	 player_positions = []
	 player_finsihed = false
	 gate_positions = []



# Called when the node enters the scene tree for the first time.
func _ready():
	var p_numb = name[-1]
	if not int(p_numb):
		p_numb = 1
	else:
		p_numb = int(p_numb)
	
	$Sprite.set_self_modulate(Settings.player_numnber_info[p_numb][0])
	
	$Icon.set_texture(load(Settings.player_numnber_info[p_numb][1]))
	$Icon.set_self_modulate(Settings.player_numnber_info[p_numb][2])
	$VBoxContainer/Energy.set_self_modulate(Settings.player_numnber_info[p_numb][2]-Color(0.1,0.1,0.1,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	
	
	
	
	pass
	
	
	
	
	
	#velocity += get_movements() *delta
	#velocity *=  FRICTION
	#self.set_collision_mask_bit(1,true)
	
	
	
	
	#var colliders = move_and_collide(velocity,true,true,true)
	
	
	#if colliders:
		
	#	if colliders.get_collider().get_collision_layer_bit(1)==true:
			#print(colliders.get_collider().get_tileset())
	#		var pos = (colliders.get_position() +colliders.get_remainder()-Vector2(1,1))#to_local

	
	#		$ColorRect.set_global_position(pos)
	#		pos = tilemap.world_to_map(pos/2)
		
#			print(tilemap.get_cell_autotile_coord(pos.x,pos.y))
#	self.set_collision_mask_bit(1,false)
	#print(self.get_collision_mask_bit(2))
#	colliders = move_and_collide(velocity)
	

	
	


#func get_movements():
#	var dir = Vector2.ZERO
#	dir.x = Input.get_action_strength("right")-Input.get_action_strength("left")
#	dir.y = Input.get_action_strength("down")-Input.get_action_strength("up")
#	dir = dir.normalized()
#	return(dir*SPEED)

func set_direction(rot):
	self.set_rotation_degrees(rot)
	direction = ($Lookat.get_global_position()-self.get_global_position()).normalized()
	direction *= Vector2(tile_size,tile_size)

func _input(event):
	
	if selected and energy >0 and level_playing == level_on and is_playing :
		if Input.is_action_pressed("up"):
			var floored_pos = Vector2(floor((position+direction).x/tile_size),floor((position+direction).y/tile_size))
			
			if wall.get_cellv((position+direction)/tile_size) == -1 and needs_release == false and  not floored_pos in player_positions and  not floored_pos in gate_positions:
				
				if move_finished:
					$Moving.play()
					move_finished =false
					emit_signal("moved",name,(position+direction)/tile_size,false)
					$Tween.interpolate_property(self,'position',position,position + direction,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN )
					$Tween.start()
					$Tween.connect("tween_all_completed",self,'move_finished')
					energy -=1
					update_energy()
			elif sound_done:
				print("INVALID")
				sound_done = false
				$Invalid.play()
				pass
		else:
			needs_release = false
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			if move_finished:
				sound_done = true
				var dire  = ceil(Input.get_action_strength("left")-Input.get_action_strength("right"))
				if dire != 0 :
					move_finished = false
					$Tween.interpolate_property(self,'rotation_degrees',rotation_degrees,rotation_degrees-(dire*90),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
					#$Tween.interpolate_property($VBoxContainer/Energy,'rect_rotation',$VBoxContainer/Energy.rect_rotation,$VBoxContainer/Energy.rect_rotation+(dire*90),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
					#$VBoxContainer/Energy.rect_pivot_offset = 0.5*$VBoxContainer/Energy.rect_size
					$Tween.start()
					yield($Tween,"tween_all_completed")
					direction = ($Lookat.get_global_position()-self.get_global_position()).normalized()
					direction *= Vector2(tile_size,tile_size)
					move_finished = true
		if Input.is_action_just_pressed("Transfer Elctricity"):
			if objects.get_cellv(position/tile_size) != -1:
				if energy > 0:
					$Transfer.play()
					emit_signal('give_electricity',objects.get_cell_autotile_coord((position.x)/tile_size,(position.y)/tile_size),self)
					#energy -=1
					#update_energy()
	
		
	elif energy < 0 and level_playing == level_on and is_playing:
		$Invalid.play()
		#sound affect
		pass
#	print('level_playnig')
#	print(level_playing)
#	print("levelon")
#	print(level_on)


func move_finished():
	print('FINISHED')
	
	$MoveCoolDown.start(cool_down)
	$Tween.disconnect("tween_all_completed",self,'move_finished')
	if  finish.get_cellv(position/tile_size) != -1:
		selected = false
		boost_slide = false
		player_finsihed = true
		trans_out()
	if chargers.get_cellv(position/tile_size) != -1:
		turn_number = 0
		print("CHARGING")
		charging = true
	else:
		charging = false
	if buttons.get_cellv(position/tile_size) != -1:
		emit_signal("button_hit",position/tile_size)
	
		if boost_slide == false:
			return
	if plates.get_cellv(position/tile_size) != -1:
		on_plate = true
		$Plate.play()
		plate_on = position/tile_size
		emit_signal("plate_hit",plate_on,true)
		if boost_slide == false:
			return
	elif on_plate:
		$Plate.play()
		on_plate = false
		emit_signal("plate_hit",plate_on,false)
		if boost_slide == false and  boosts.get_cellv(position/tile_size) == -1:
			return
		#needs_release = true
	
	if boosts.get_cellv(position/tile_size) != -1:
		var x_flip = (boosts.is_cell_y_flipped((position.x)/tile_size,(position.y)/tile_size))
		var y_flip  = (boosts.is_cell_x_flipped((position.x)/tile_size,(position.y)/tile_size))
	
		#RIGHT IS FALSE FALSE
		#UP IS TRUE FALSE
		#LEFT IS TRUE TURE
		#DOWN IS FALSE TRUE
		var dir
		if x_flip:
			if y_flip:
				dir = Vector2(-tile_size,0)
			else:
				dir = Vector2(0,-tile_size)
		elif y_flip:
			dir = Vector2(0,tile_size)
		else:
			dir = Vector2(tile_size,0)
		var time = 0.3
		
		if boosts.get_cellv(position/tile_size) == 1:
			boost_slide = true
			slide_dir = dir
			$UltraBoost.play()
			time = 0.1
		else:
			boost_slide = false
			$Boost.play()
		if wall.get_cellv((position+dir)/tile_size) == -1 and not Vector2(floor((position.x+dir.x)/tile_size),floor((position.y+dir.y)/tile_size)) in gate_positions and not Vector2(floor((position.x+dir.x)/tile_size),floor((position.y+dir.y)/tile_size)) in player_positions: 
			emit_signal("moved",name,(position+dir)/tile_size,true)
			$Tween.interpolate_property(self,'position',position,position + dir,time,Tween.TRANS_LINEAR,Tween.EASE_IN )
			$Tween.start()
			$Tween.connect("tween_all_completed",self,'move_finished')
		
	elif boost_slide:
		if wall.get_cellv((position+slide_dir)/tile_size) == -1 and not Vector2(floor((position.x+slide_dir.x)/tile_size),floor((position.y+slide_dir.y)/tile_size)) in gate_positions and not Vector2(floor((position.x+slide_dir.x)/tile_size),floor((position.y+slide_dir.y)/tile_size)) in player_positions: 
			move_finished = false
		
			emit_signal("moved",name,(position+slide_dir)/tile_size,true)
			$Tween.interpolate_property(self,'position',position,position + slide_dir,0.1,Tween.TRANS_LINEAR,Tween.EASE_IN )
			$Tween.start()
			$Tween.connect("tween_all_completed",self,'move_finished')
		else:
			emit_signal("full_move_done")
			boost_slide = false
			yield($MoveCoolDown,"timeout")
			move_finished = true
	else:
		yield($MoveCoolDown,"timeout")
		move_finished = true
		emit_signal("full_move_done")

func select():
	$highlight.show()
	selected = true

func deselect():
	$highlight.hide()
	selected = false


func _on_Select_pressed():

	if level_playing == level_on and is_playing:
		emit_signal("selected",name)
		select()
	else:
		print(level_playing)
		print(level_on)

func update_energy():
	$VBoxContainer/Energy.set_text(str(energy))
	#$VBoxContainer/Icon.rect_position.x = 3+(($VBoxContainer/Energy.get_size().x-8) *.5)

func player_moved():
	if charging and move_finished and is_playing: #and #turn_number>0:
		energy+=1
		emit_signal('charged')
		update_energy()
	if  is_playing:
		if boosts.get_cellv(position/tile_size) != -1:
			var x_flip = (boosts.is_cell_y_flipped((position.x)/tile_size,(position.y)/tile_size))
			var y_flip  = (boosts.is_cell_x_flipped((position.x)/tile_size,(position.y)/tile_size))
		
			#RIGHT IS FALSE FALSE
			#UP IS TRUE FALSE
			#LEFT IS TRUE TURE
			#DOWN IS FALSE TRUE
			var dir
			if x_flip:
				if y_flip:
					dir = Vector2(-tile_size,0)
				else:
					dir = Vector2(0,-tile_size)
			elif y_flip:
				dir = Vector2(0,tile_size)
			else:
				dir = Vector2(tile_size,0)
			var time = 0.3
			
			if boosts.get_cellv(position/tile_size) == 1:
				boost_slide = true
				slide_dir = dir
				
				time = 0.1
			else:
				boost_slide = false
			if wall.get_cellv((position+dir)/tile_size) == -1 and not Vector2(floor((position.x+dir.x)/tile_size),floor((position.y+dir.y)/tile_size)) in gate_positions and not Vector2(floor((position.x+dir.x)/tile_size),floor((position.y+dir.y)/tile_size)) in player_positions: 
				emit_signal("moved",name,(position+dir)/tile_size,true)
				$Tween.interpolate_property(self,'position',position,position + dir,time,Tween.TRANS_LINEAR,Tween.EASE_IN )
				$Tween.start()
				$Tween.connect("tween_all_completed",self,'move_finished')
		
		
	#turn_number +=1

func trans_out():
	$Finished.play()
	print('trans')
	$Tween.interpolate_property(self,'modulate',self.modulate,Color(self.modulate.r,self.modulate.g,self.modulate.b,0),0.5,Tween.TRANS_BACK,Tween.EASE_IN)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	emit_signal("finished",name,self)
	
