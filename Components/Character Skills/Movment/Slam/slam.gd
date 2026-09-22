class_name SlamSkill
extends CharacterSkill

@export var slam_speed : float = 300
#var slam_direction: Vector3 = Vector3(0,-1,0)

#TODO : la direccion no jala bien
#TODO : no es sostenido, se desactiva al cumplir con la condision "is on floor" o al ser interumpido

func _physics_process(delta: float) -> void:
	#print(is_skill_active)
	if self.is_skill_active and not skill_owner.is_on_floor() :
		#print("slam_speed = ", slam_speed)
		self.skill_owner.velocity.z = 0
		self.skill_owner.velocity.x = 0
		self.skill_owner.velocity.y = slam_speed
		self.skill_owner.move_and_slide()
	else :
		self.skill_finished.emit()
