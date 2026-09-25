class_name SlamSkill
extends CharacterSkill

@export var slam_speed : float = 300
#var slam_direction: Vector3 = Vector3(0,-1,0)

#TODO : la direccion no jala bien
#TODO : no es sostenido, se desactiva al cumplir con la condision "is on floor" o al ser interumpido

#func _ready():
	#skill_finished.connect(prolong_slam)
	#print("wtf")

func _physics_process(delta: float) -> void:
	#print(is_skill_active)
	if self.is_skill_active and not skill_owner.is_on_floor() :
		#print("slam_speed = ", slam_speed)
		skill_owner.velocity.z = 0
		skill_owner.velocity.x = 0
		skill_owner.velocity.y = slam_speed
		skill_owner.move_and_slide()
	elif is_skill_active :
		skill_finished.emit()
		print(is_skill_active)
#	WARNING
	if not skill_finished.is_connected(prolong_slam):
		skill_finished.connect(prolong_slam)

func prolong_slam():
	skill_owner.velocity.y = slam_speed
	#print("awdadawdawd")
