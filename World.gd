extends Node3D

const RADIUS = 64
const MAP = Vector3(RADIUS,RADIUS,RADIUS)
const THRESHOLD = 0.5
const SPACING = 1
var gm:GridMap
var noise:FastNoiseLite

# Called when the node enters the scene tree for the first time.
func _ready():
	# WORLD GENERATION IS DONE
	randomize()
	gm = get_child(0)
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.fractal_octaves = 2
	noise.frequency = 0.05
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	var super_position = RADIUS/2.0 + 2
	var center = MAP/2
	for x in range(-center.x,center.x+1):
		for y in range(-center.y,center.y+1):
			for z in range(-center.z,center.z+1):
				var pos = Vector3(x,y,z) * SPACING
				if pos.distance_to(Vector3i(0,0,0)) > super_position :
					continue
				elif pos.distance_to(Vector3i(0,0,0)) <= super_position and pos.distance_to(Vector3i(0,0,0)) >= super_position-1 : 
					gm.set_cell_item(pos,0)
					continue
				
				var value = noise.get_noise_3dv(pos)
				if (-1*value) < THRESHOLD:
					continue
				if check_neighbours(pos):
					continue
				gm.set_cell_item(pos,0)


	
	#loop through the map and setup each block
func check_neighbours(pos): #dont skip...
	var points = 0
	for x in range(-1,2):
		for y in range(-1,2):
			for z in range(-1,2):
				var check_pos = Vector3(pos.x+x,pos.y+y,pos.z+z)
				if check_pos == pos:
					continue
				if (-1*noise.get_noise_3dv(check_pos)) > THRESHOLD: #checks if its buildable
					points+=1
	if points == 26:
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
