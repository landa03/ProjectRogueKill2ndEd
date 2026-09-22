class_name SlideSkill
extends CharacterSkill

@export var slide_speed : float
var slide_direction: Vector3 = Vector3(0,0,-1)

#TODO : la direccion no jala bien

func _physics_process(delta: float) -> void:
	#print(is_skill_active, skill_owner)
	if self.is_skill_active and skill_owner.is_on_floor() :
		#self.skill_owner.move_and_slide(self.skill_owner.position + dash_direction * dash_speed)
		#if dash_direction.is_zero_approx():
		if slide_direction.length() < 0.25:
			slide_direction = Vector3(0,0,-1).rotated(self.skill_owner.up_direction, self.skill_owner.rotation.y)
		#print("slide_direction * slide_speed = ", slide_direction * slide_speed)
		self.skill_owner.velocity.x = self.slide_direction.x * slide_speed
		self.skill_owner.velocity.z = self.slide_direction.z * slide_speed
		self.skill_owner.velocity.y = 0
		
	#print("slide_direction = ", dash_direction)
