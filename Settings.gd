extends Node
var level_on_file  = "user://level_on"

var player_numnber_info= { #{color, icon, icon color
	1: [Color(1,0,0,1),'res://Icons/Square.png',Color(0,1,0,1),0 ] ,
	2: [Color(0,0,1,1),"res://Icons/Diamond.png",Color(1,1,0.2,1)],
	3: [Color(1,1,0,1),"res://Icons/Octogon.png",Color(.63,.13,.94,1)],
	4: [Color(1,.65,0,1),"res://Icons/Pentagon.png",Color(.37,.62,.75,1)]
}



func get_level_on():
	return(load_level())

func save_level(value):
	var f = File.new()
	f.open(level_on_file,File.WRITE)
	f.store_var(value)
	f.close()

func load_level():
	var f = File.new()
	var out = 1
	if f.file_exists(level_on_file):
		f.open(level_on_file,File.READ)
		out = f.get_var()
		f.close()
	
	return(out)
	
