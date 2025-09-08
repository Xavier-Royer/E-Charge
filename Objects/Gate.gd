extends AnimatedSprite
var state = 0
signal gate_switched

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("animation_finished",self,'animation_done')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func switch_state():
	$AudioStreamPlayer2D.play()
	if state ==0:
		self.play('Gate')
		state = 1
	else:
		self.play('Gate',true)
		state  = 0 

func animation_done():
	self.stop()
	if state == 1:
		self.frame = 9 
	else:
		self.frame = 0 
	
	$Timer.start(0.2)
	yield($Timer,"timeout")
	emit_signal("gate_switched")
