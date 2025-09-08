extends Node2D
signal level_complete
var level_number = 0
var player_selected 
var level = 1
var total_players
var gates= []
var buttons = []
var plates = []
var total_gates =  8
var map_x = 30
var map_y = 30
var gate_node = preload("res://Objects/Gate.tscn")
var button_node = preload("res://Objects/Button.tscn")
var plate_node = preload("res://Objects/PressurePlate.tscn")
var transfer_node = preload("res://Objects/Transfer.tscn")
var tilesize = 40
var player_positions = []
var players = []
var transfers = []
var gate_positions = []
var playing_level = false
var offset = Vector2(.5*tilesize,.5*tilesize)
signal lost
signal down
signal station_used
signal time
signal charger
var hint_time = 10
var level_finished = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func setup():
	level_finished = false
	if level_number == int(name) :
		for i in $Gate_holder.get_children():
			i.queue_free()
		for i in $Button_holder.get_children():
			i.queue_free()
		for i in $PressurePlate_holder.get_children():
			i.queue_free()
		for i in $Objects.get_children():
			i.queue_free()
		gates= []
		buttons = []
		plates = []
		player_positions = []
		players = []
		transfers = []
		gate_positions = []
		$Gates.set_modulate(Color(0,0,0,0))
		$Buttons.set_modulate(Color(0,0,0,0))
		$Plates.set_modulate(Color(0,0,0,0))
		$Objects.set_modulate(Color(0,0,0,0))
		#x index presents thier color, the gates arrays are [(x,y)/node_name, 0 or 1/gate state
		for i in total_gates:
			gates.append([])
			buttons.append([])
			plates.append([])
			transfers.append([])
		if level_number == int(name):
			var t = Timer.new()
			add_child(t)
			t.start(hint_time)
			t.connect("timeout",self,"timeout")
			for x in map_x:
				for y in map_y:
					if $Gates.get_cell(x,y) != -1:
						var gate_num = $Gates.get_cell_autotile_coord(x,y).x
						var gate_state =$Gates.get_cell(x,y)
						var x_flip = $Gates.is_cell_x_flipped(x,y)
						var y_flip = $Gates.is_cell_y_flipped(x,y)
						var gate_rot
						if x_flip:
							if y_flip:
								gate_rot  = 180
							else:
								gate_rot = 90
						elif y_flip:
							gate_rot = 270
						else:
							gate_rot = 0 
					
					
						var gate_name = str(x)+','+str(y)
						var g = gate_node.instance()
						$Gate_holder.add_child(g)
						g.set_name(gate_name)
						g.position = Vector2(x,y)*tilesize +Vector2(.5*tilesize,.5*tilesize)
						g.rotation_degrees = gate_rot
						g.set_modulate(Settings.player_numnber_info[int(gate_num+1)][0])
					
						if int(gate_state) == 1:
							g.set_frame(9)
						
						else:
							g.set_frame(0)
							gate_positions.append(Vector2(x,y))
						g.state = gate_state
					
					
						gates[gate_num].append([gate_name,gate_state])
					if $Buttons.get_cell(x,y) !=-1:
						var button_num = $Buttons.get_cell_autotile_coord(x,y).x
						var button_state =$Buttons.get_cell(x,y)
						var button_name = str(x)+','+str(y)
						var g = button_node.instance()
						$Button_holder.add_child(g)
						g.set_name(button_name)
						g.position = Vector2(x,y)*tilesize #+Vector2(.5*tilesize,.5*tilesize)
						g.set_modulate(Settings.player_numnber_info[int(button_num+1)][0])
						g.button_state = 1-button_state
						g.button_number  = button_num
						g.switch_state()
						buttons[button_num].append([button_name,button_state])
					if $Plates.get_cell(x,y) != -1:
						var plate_num = $Plates.get_cell_autotile_coord(x,y).x
						var plate_state =$Plates.get_cell(x,y)
						var plate_name = str(x)+','+str(y)
						var g = plate_node.instance()
						$PressurePlate_holder.add_child(g)
						g.set_name(plate_name)
						g.position = Vector2(x,y)*tilesize #+Vector2(.5*tilesize,.5*tilesize)
						g.set_modulate(Settings.player_numnber_info[int(plate_num+1)][0])
						g.set_state(1) #Sets to up state
					#g.plate_state = 1-plate_state
						g.plate_number  = plate_num
					#g.switch_state()
						plates[plate_num].append([plate_name,plate_state])
					if $Objects.get_cell(x,y) != -1:
						var t_num = $Objects.get_cell_autotile_coord(x,y).x
						var t_state =$Objects.get_cell(x,y)
						var t_name = str(x)+','+str(y)
						var g = transfer_node.instance()
						$Transfer_holder.add_child(g)
						g.set_name(t_name)
						g.position = Vector2(x,y)*tilesize #+Vector2(.5*tilesize,.5*tilesize)
						#g.set_modulate(Settings.player_numnber_info[int(t_num+1)][0])
						g.setup(int(t_num+1))
					#	g.set_state(1) #Sets to up state
						#g.plate_state = 1-plate_state
						g.number  = t_num
						#g.setup()
						#g.switch_state()
						transfers[t_num].append([t_name,t_state])
					
		
		if level_number ==1:
			
			$Player.set_direction(90)
			$Player2.set_direction(-90)
			$Player.set_position(Vector2(6*tilesize,10*tilesize)+offset)
			$Player.energy = 13
			$Player2.set_position(Vector2(18*tilesize,9*tilesize)+offset )
			$Player2.energy =  10 
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number ==2:
			
			$Player.set_direction(90)
			$Player2.set_direction(90)
			$Player.set_position(Vector2(7*tilesize,10*tilesize)+offset)
			$Player.energy = 19
			$Player2.set_position(Vector2(7*tilesize,6*tilesize)+offset )
			$Player2.energy =  0
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number ==5:
			
			$Player.set_direction(90)
			$Player2.set_direction(90)
			$Player.set_position(Vector2(8*tilesize,10*tilesize)+offset)
			$Player.energy = 9
			$Player2.set_position(Vector2(17*tilesize,5*tilesize)+offset )
			$Player2.energy =  0
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		
		elif level_number ==3:
			
			$Player.set_direction(90)
			$Player2.set_direction(90)
			$Player.set_position(Vector2(8*tilesize,7*tilesize)+offset)
			$Player.energy = 0
			$Player2.set_position(Vector2(10*tilesize,11*tilesize)+offset )
			$Player2.energy =  12
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 4:
				
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player.set_position(Vector2(18*tilesize,5*tilesize)+offset)
			$Player.energy = 11
			$Player2.set_position(Vector2(10*tilesize,9*tilesize)+offset )
			$Player2.energy =  2
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number ==6:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player.set_position(Vector2(8*tilesize,3*tilesize)+offset)
			$Player.energy = 14
			$Player2.set_position(Vector2(22*tilesize,5*tilesize)+offset )
			$Player2.energy =  2
			$Player.selected = true
			player_selected = 1
			total_players = 2
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number ==7:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(17*tilesize,8*tilesize)+offset)
			$Player2.set_position(Vector2(12*tilesize,3*tilesize)+offset )
			$Player3.set_position(Vector2(9*tilesize,10*tilesize)+offset )
			
			$Player.energy = 2
			$Player2.energy =  3
			$Player3.energy =  17
			
			$Player3.selected = true
			player_selected = 3
			total_players = 3
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 8:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(14*tilesize,2*tilesize)+offset)
			$Player2.set_position(Vector2(12*tilesize,2*tilesize)+offset )
			$Player3.set_position(Vector2(18*tilesize,6*tilesize)+offset )
			
			$Player.energy = 7
			$Player2.energy =  0
			$Player3.energy =  9
			
			$Player3.selected = true
			player_selected = 3
			total_players = 3
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 9:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(8*tilesize,5*tilesize)+offset)
			$Player2.set_position(Vector2(15*tilesize,10*tilesize)+offset )
			$Player3.set_position(Vector2(15*tilesize,6*tilesize)+offset )
			
			$Player.energy = 6
			$Player2.energy =  6
			$Player3.energy =  2
			
			$Player3.selected = true
			player_selected = 3
			total_players = 3
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 10:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(8*tilesize,4*tilesize)+offset)
			$Player2.set_position(Vector2(8*tilesize,9*tilesize)+offset )
			$Player3.set_position(Vector2(18*tilesize,3*tilesize)+offset )
			
			$Player.energy = 22
			$Player2.energy = 1
			$Player3.energy =  0
			
			$Player3.selected = true
			player_selected = 3
			total_players = 3
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 11:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(12*tilesize,4*tilesize)+offset)
			$Player2.set_position(Vector2(17*tilesize,8*tilesize)+offset )
			$Player3.set_position(Vector2(7*tilesize,8*tilesize)+offset )
			
			$Player.energy = 1
			$Player2.energy = 11
			$Player3.energy =  0
			
			$Player3.selected = true
			player_selected = 3
			total_players = 3
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 12:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(15*tilesize,3*tilesize)+offset)
			$Player2.set_position(Vector2(11*tilesize,3*tilesize)+offset )
			$Player3.set_position(Vector2(7*tilesize,5*tilesize)+offset )
			$Player4.set_position(Vector2(19*tilesize,7*tilesize)+offset )
			
			$Player.energy = 0
			$Player2.energy = 0
			$Player3.energy =  0
			$Player4.energy =  13
			
			$Player4.selected = true
			player_selected = 4
			total_players = 4
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 13:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(19*tilesize,5*tilesize)+offset)
			$Player2.set_position(Vector2(17*tilesize,9*tilesize)+offset )
			$Player3.set_position(Vector2(13*tilesize,2*tilesize)+offset )
			$Player4.set_position(Vector2(7*tilesize,6*tilesize)+offset )
			
			$Player.energy = 3
			$Player2.energy = 0
			$Player3.energy =  10
			$Player4.energy =  2
			
			$Player4.selected = true
			player_selected = 4
			total_players = 4
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 14:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(10*tilesize,3*tilesize)+offset)
			$Player2.set_position(Vector2(19*tilesize,4*tilesize)+offset )
			$Player3.set_position(Vector2(5*tilesize,8*tilesize)+offset )
			$Player4.set_position(Vector2(18*tilesize,8*tilesize)+offset )
			
			$Player.energy = 0
			$Player2.energy = 0
			$Player3.energy =  6
			$Player4.energy =  7
			
			$Player4.selected = true
			player_selected = 4
			total_players = 4
			var p = get_player_by_number(player_selected)
			p.select()
		elif level_number == 15:
			$Player.set_direction(-90)
			$Player2.set_direction(90)
			$Player3.set_direction(90)
			
			$Player.set_position(Vector2(6*tilesize,11*tilesize)+offset)
			$Player2.set_position(Vector2(15*tilesize,7*tilesize)+offset )
			$Player3.set_position(Vector2(15*tilesize,8*tilesize)+offset )
			$Player4.set_position(Vector2(16*tilesize,7*tilesize)+offset )
			
			$Player.energy = 0
			$Player2.energy = 3
			$Player3.energy =  4
			$Player4.energy =  5
			player_moved("Player4",Vector2(16,7),false)
			$Player4.selected = true
			player_selected = 4
			total_players = 4
			var p = get_player_by_number(player_selected)
			p.select()

			
		for i in get_tree().get_nodes_in_group('players'):
			if i.get_parent()== self:
				i.show()
				i.set_modulate(Color(1,1,1,1))
				i.level_on = int(name)
				i.level_playing = level_number
				if not i.is_connected('give_electricity',self,'transfer_energy'):
					i.connect("full_move_done",self,'check_energy')
					i.connect("charged",self,"charged")
					i.connect('give_electricity',self,'transfer_energy')
					i.connect('selected',self,'select')
					i.connect('button_hit',self,'button_pressed')
					i.connect('plate_hit',self,'plate_hit')
					i.connect('moved',self,'player_moved')
					i.connect('finished',self,'player_finished')
				i.update_energy()
				var pos = i.get_position()/tilesize
				player_positions.append(Vector2(floor(pos.x),floor(pos.y)))
				players.append(true)
				i.player_finsihed = false
				
		for i in get_tree().get_nodes_in_group('players'):
			if i.get_parent()== self:
				i.player_positions = player_positions
				i.gate_positions = gate_positions
				i.reset()
	else:
		for i in get_tree().get_nodes_in_group('players'):
			if i.get_parent()== self:
				i.reset()
				i.level_on = int(name)
				i.level_playing = level_number

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func transfer_energy(receiving_player,giving_player):
	if level_number == int(name) and playing_level:
		#print(receiving_player)
		var p = get_player_by_number(receiving_player.x+1)
		if p.player_finsihed  == false:
			emit_signal('station_used')
			p.energy +=1 
			giving_player.energy-=1
			giving_player.update_energy()
			p.update_energy()
		

func _input(event):
	if level_number == int(name) and playing_level:
		if Input.is_action_just_pressed("down"):
			emit_signal("down")
			print('switch')
			select_next_player()
	

func select_next_player():
	if level_number == int(name) and playing_level:
		var p = get_player_by_number(player_selected)
		p.deselect()
		for i in range(total_players):
			player_selected+=1 
			if player_selected >total_players:
				player_selected = 1
			if players[player_selected-1]:
				break
		p = get_player_by_number(player_selected)
		p.select()

func get_player_by_number(number):
	var node_name = "Player" 
	if number > 1:
		node_name += str(number)
	return(self.get_node(node_name))

func select(player_name):
	if level_number == int(name) and playing_level:
		var p = get_player_by_number(player_selected)
		p.deselect()
		var num  = player_name[-1]
		if int(num):
			player_selected = int(num)
		else:
			player_selected = 1
	#print(player_selected)

func button_pressed(coords):
	if level_number == int(name)  and playing_level:
		
		var button = $Button_holder.get_node(str(floor(coords.x)) + ','  +str(floor(coords.y)))
		for i in gates[button.button_number]:
			var p = Vector2(floor($Gate_holder.get_node(i[0]).position.x/tilesize),floor($Gate_holder.get_node(i[0]).position.y/tilesize))
			#FOR SWITCHING THE COLLISION
			if  p in player_positions:
				for x in get_tree().get_nodes_in_group("players"):
					x.move_finished = true
					x.gate_positions = gate_positions
				return
				#cant close on player
		
		button.switch_state()
		for i in get_tree().get_nodes_in_group("players"):
			i.move_finished = false
		for i in gates[button.button_number]:
			$Gate_holder.get_node(i[0]).switch_state()
			var p = $Gate_holder.get_node(i[0]).position/tilesize
			#FOR SWITCHING THE COLLISION
			if not p in player_positions:
				if int($Gate_holder.get_node(i[0]).state) == int(1):
				
				
					gate_positions.remove(gate_positions.find(Vector2(floor(p.x),floor(p.y))))
				else:
			
					gate_positions.append(Vector2(floor(p.x),floor(p.y)))
		print(gate_positions)
		yield($Gate_holder.get_node(gates[button.button_number][0][0]),'gate_switched')
		for i in get_tree().get_nodes_in_group("players"):
			i.move_finished = true
			i.gate_positions = gate_positions


func plate_hit(coords,down):
	if level_number == int(name) and playing_level:
		var plate = $PressurePlate_holder.get_node(str(floor(coords.x)) + ','  +str(floor(coords.y)))
		for i in gates[plate.plate_number]:
			var p = Vector2(floor($Gate_holder.get_node(i[0]).position.x/tilesize),floor($Gate_holder.get_node(i[0]).position.y/tilesize))
			#FOR SWITCHING THE COLLISION
			if p in player_positions:
				for x in get_tree().get_nodes_in_group("players"):
					x.move_finished = true
					x.gate_positions = gate_positions
				return
				#can't close on player
				
		
		if down:
			plate.pressed()
		else:
			plate.released()
		for i in get_tree().get_nodes_in_group("players"):
			i.move_finished = false
		for i in gates[plate.plate_number]:
			$Gate_holder.get_node(i[0]).switch_state()
			var p = $Gate_holder.get_node(i[0]).position/tilesize
			#FOR SWITCHING THE COLLISION
		
			if int($Gate_holder.get_node(i[0]).state) == int(1):
				
				gate_positions.remove(gate_positions.find(Vector2(floor(p.x),floor(p.y))))
			else:
				
				gate_positions.append(Vector2(floor(p.x),floor(p.y)))
			print(gate_positions)
				
		yield($Gate_holder.get_node(gates[plate.plate_number][0][0]),'gate_switched')
		for i in get_tree().get_nodes_in_group("players"):
			i.gate_positions = gate_positions
			print(gate_positions)
			i.move_finished = true


func player_moved(player, pos,boosting):
	
	if level_number == int(name)  and playing_level:
		var player_numb = player.lstrip("Player")
		if player_numb == '':
			player_numb = 1
		else:
			player_numb = int(player_numb)
		player_positions[player_numb-1] = Vector2(floor(pos.x),floor(pos.y))
		
		for i in get_tree().get_nodes_in_group('players'):
			if i.get_parent() == self:
				print("PLAYER")
				if  boosting == false and i.player_finsihed == false:
					
					var p 
					if i == self.get_node(player):
						p = pos *tilesize
					else:
						p= i.get_position()
					var pp = Vector2(floor(p.x/tilesize),floor(p.y/tilesize))
					print(pp)
					i.player_moved()
					var removed = player_positions.duplicate(true)
					removed.remove(player_positions.find(pp))
					i.player_positions = removed
					print(removed)

func player_finished(player_name,player):
	print('p finsihed5')
	if level_number == int(name)  and playing_level:
		player.deselect()
		var player_numb = player_name.lstrip("Player")
		if player_numb == '':
			player_numb = 1
		else:
			player_numb = int(player_numb)
		players[player_numb-1]= false
		if players.has(true):
			select_next_player()
			
			player_positions[player_numb-1] = null
			
		else:
			emit_signal('level_complete')
			level_finished = true
			print('level_fnihsed')
			pass
			#level compltete

func start_play():
	playing_level = true
	for i in get_tree().get_nodes_in_group("players"):
		i.is_playing = true

func stop_play():
	playing_level = false
	for i in get_tree().get_nodes_in_group("players"):
		i.is_playing = false

func check_energy():
	var total_e = 0
	var p = 0 
	
	
	for i in get_tree().get_nodes_in_group('players'):
		if i.get_parent()== self and i.player_finsihed == false:
			total_e+=i.energy
			if i.player_finsihed == false:
				
				p+=1
	if total_e <1 and p>0:
		print("NO ENGERY ")
		emit_signal('lost')
	else:
		print(total_e)
		print("ENGERY In play")
func timeout():
	emit_signal('time')
func charged():
	emit_signal('charger')

