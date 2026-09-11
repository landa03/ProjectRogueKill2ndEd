class_name SlamSkill
extends CharacterSkill

@export var slam_speed : float = 300
#var slam_direction: Vector3 = Vector3(0,-1,0)

#TODO : la direccion no jala bien

func _physics_process(delta: float) -> void:
	#print(is_skill_active)
	if self.is_skill_active :
		print("slam_speed = ", slam_speed)
		self.skill_owner.velocity.z = 0
		self.skill_owner.velocity.x = 0
		self.skill_owner.velocity.y = slam_speed
		self.skill_owner.move_and_slide()
