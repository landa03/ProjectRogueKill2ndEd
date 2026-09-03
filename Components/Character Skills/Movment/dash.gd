class_name DashSkill
extends CharacterSkill

@export var dash_speed : float
var dash_direction: Vector3 = Vector3(0,0,-1)

#func _ready():

func _physics_process(delta: float) -> void:
	if self.is_skill_active :
		#self.skill_owner.move_and_slide(self.skill_owner.position + dash_direction * dash_speed)
		#if dash_direction.is_zero_approx():
		print("dash_direction.length() = ", dash_direction.length(), ", dash_direction = ",dash_direction)
		if dash_direction.length() < 0.25:
			dash_direction = Vector3(0,0,-1).rotated(self.skill_owner.up_direction, self.skill_owner.rotation.y)
		#self.skill_owner.velocity = self.skill_owner.position + dash_direction * dash_speed
		self.skill_owner.velocity.x = self.dash_direction.x * dash_speed
		self.skill_owner.velocity.y = self.dash_direction.y * dash_speed
		
	#print("dash_direction = ", dash_direction)
