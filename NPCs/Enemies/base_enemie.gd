extends RigidBody3D

#TODO:
#	DETECTION
#	NAVEGATION
#	SKILLS
#	HP
#	FACTION

#NAVEGATION:
#	ROAMING
#	INVESTIGATE
#	ATACK
#		RANGE
#		MELE
#	DEFEND
#		TAKE COVER
#		GET IN THE WAY (BLOCK / TAKE TANK THE ATAKS)
#		SUPORTIVE SKILLS

#FACTION
#	ENEMY FACTION
#	ALIE FACTIONS
#	HELP ALIE
#	ATACK ENEMIE

@export var nav_agent: NavigationAgent3D
var current_location: Vector3
var next_location: Vector3
var new_velosity: Vector3

var speed = 3

@export var detection_area: Area3D
var character_to_attack: RigidBody3D
@export var roam_range: float = 10
var initial_position: Vector3

func _ready() -> void:
	nav_agent.target_position = Vector3(0,0,0)
	detection_area.body_entered.connect(_on_body_entered_detection_area)
	initial_position = global_position
	nav_agent.path_changed.connect(aaaaa)
	
func aaaaa():
	print("aofenkbnnoiun")

func _on_body_entered_detection_area(body):
	if body is RigidBody3D:
		print("body is RigidBody3D")
		for group in body.get_groups():
			if group == "Ally":
				print("body is Ally")
				character_to_attack = body
				#update_target_location(body.global_position)
		
		
func _physics_process(delta: float) -> void:
	print("next_location = ", next_location)
	print("current_location = ", current_location)
	current_location = global_position
	#next_location = nav_agent.get_next_path_position()
	next_location = nav_agent.target_position
	new_velosity = (next_location - current_location).normalized() * speed
	
	linear_velocity.x = new_velosity.x
	linear_velocity.z = new_velosity.z
	if character_to_attack:
		nav_agent.target_position = character_to_attack.global_position
	else:
		nav_agent.target_position.x = initial_position.x + randf_range(-roam_range, roam_range)
		nav_agent.target_position.z = initial_position.z + randf_range(-roam_range, roam_range)
		nav_agent.target_position.y = initial_position.y
		
	
func update_target_location(target_location: Vector3):
	nav_agent.target_position = target_location
