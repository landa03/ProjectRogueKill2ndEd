class_name SlamSkill
extends CharacterSkill

@export var slam_speed : float = 30
#var slam_direction: Vector3 = Vector3(0,-1,0)

#TODO : la direccion no jala bien
#TODO : no es sostenido, se desactiva al cumplir con la condision "is on floor" o al ser interumpido

func _ready() -> void:
	skill_ready()

func _physics_process(delta: float) -> void:
	#print(is_skill_active)
	if is_skill_active:
		#skill_owner.linear_velocity = Vector3(0,-slam_speed,0)
		
		skill_owner.linear_velocity.x = 0
		skill_owner.linear_velocity.z = 0
		skill_owner.apply_central_impulse(Vector3(0,-slam_speed,0))
#	WARNING
	#if not skill_finished.is_connected(prolong_slam):
		#skill_finished.connect(prolong_slam)

#func prolong_slam():
	#skill_owner.velocity.y = slam_speed
	#print("awdadawdawd")
