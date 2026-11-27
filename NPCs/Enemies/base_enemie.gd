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

enum NavegationState {ROAMING, INVESTIGATE, ATACK, DEFEND, UNKNOWN}
var current_navegation_state: NavegationState = NavegationState.ROAMING

@export var nav_agent: NavigationAgent3D
@export var detection_area: Area3D
@export var roam_range: float = 30
@export var speed = 3
@export var healthpoints: HealthPoints
@export var atack_range: float = 10

var next_location: Vector3
var new_velosity: Vector3
var character_to_attack: RigidBody3D #TODO: dosnt have to be a RigidBody3D, just a node3D
var initial_position: Vector3

var is_navegation_timer_mid_cycle: bool = false
@export var is_navegation_timer_one_shot: bool = false
var navegation_timer_time: float = 0
@export var navegation_timer_wait_time: float = 1

func _ready() -> void:
	nav_agent.target_position = Vector3(0,0,0)
	detection_area.body_entered.connect(_on_body_entered_detection_area)
	initial_position = global_position
	

func navegation_timer_timeout():
	is_navegation_timer_mid_cycle = false
	if character_to_attack:
		#nav_agent.target_position = character_to_attack.global_position
		nav_agent.set_target_position(character_to_attack.global_position)

	else:
		nav_agent.target_position.x = initial_position.x + randf_range(-roam_range, roam_range)
		nav_agent.target_position.z = initial_position.z + randf_range(-roam_range, roam_range)
		nav_agent.target_position.y = initial_position.y + 1
	
	next_location = nav_agent.get_next_path_position()
	new_velosity = (next_location - global_position).normalized() * speed
	
	linear_velocity.x = new_velosity.x
	linear_velocity.z = new_velosity.z
	#print("ring ring", navegation_timer_time)
	#print("nav_agent.target_position = ", nav_agent.target_position)
	#print("nav_agent.get_next_path_position() = ", nav_agent.get_next_path_position())
	#print("global_position = ", global_position)

var faction_entities_inside_detection_area: Array[Node3D]


func _on_body_entered_detection_area(body: Node3D):
	for node in body.get_children():
		if node is HealthPoints:
			#if !enemies_inside_detection_area.has(body) and node.Faction != healthpoints.Faction and openent_factions.any(is_alied_faction):
			if !faction_entities_inside_detection_area.has(body):
				faction_entities_inside_detection_area.append(body)
				print(faction_entities_inside_detection_area)
				print("it can bleed!!")
			
		
	if body is RigidBody3D:
		#print("body is RigidBody3D")
#		TODO: make it work based on hp not in group
		for group in body.get_groups():
			if group == "Ally":
				#print("body is Ally")
				change_state(NavegationState.ATACK)
				character_to_attack = body
				#update_target_location(body.global_position)
		
		
func _physics_process(delta: float) -> void:
#	NAVEGATION_TIMER/
	if navegation_timer_time < navegation_timer_wait_time:
		#print("navegation_timer_time = ",navegation_timer_time)
		navegation_timer_time = navegation_timer_time + delta
		is_navegation_timer_mid_cycle = true
	elif is_navegation_timer_mid_cycle and is_navegation_timer_one_shot:
		is_navegation_timer_mid_cycle = false
		navegation_timer_timeout()
	else:
		navegation_timer_time = 0
		navegation_timer_timeout()
		
#	/NAVEGATION_TIMER
	
func change_state(new_state: NavegationState):
#	ATACK
#		enemie is detected and enemie is in atack_range 
#	DEFEND
#		enemie is detected and enemie is not in atack_range and alie is in range (or somthing)
#	INVESTIGATE
#		enemie was detected (isnt detected, was)
#	ROAM
#		no enemie is detecter and enemie_detected_timer on time_out
	match new_state:
		NavegationState.UNKNOWN:
			for body in detection_area.get_overlapping_bodies():
				for node in body.get_children():
					if node is HealthPoints:
						for faction in healthpoints.openent_factions:
							if node.Faction == faction:
								if global_position.distance_to(body.global_position) <= atack_range:
									new_state = NavegationState.ATACK
								else:
									new_state = NavegationState.INVESTIGATE
						for faction in healthpoints.alied_factions:
							if node.Faction == faction:
								pass
								
					#faction_entitie
		NavegationState.ATACK:
			current_navegation_state = NavegationState.ATACK
