class_name SlideSkill
extends CharacterSkill

@export var slide_speed : float
var slide_direction: Vector3 = Vector3(0,0,-1)

#TODO : la direccion no jala bien

func _ready() -> void:
	skill_ready()

func _physics_process(delta: float) -> void:
	#print(is_skill_active, skill_owner)
	if is_skill_active:
		#print(skill_owner.linear_velocity.length())
		#self.skill_owner.move_and_slide(self.skill_owner.position + dash_direction * dash_speed)
		#if dash_direction.is_zero_approx():

		#print("slide_direction * slide_speed = ", slide_direction * slide_speed)
		#skill_owner.apply_central_force(slide_direction * slide_speed)
		skill_owner.linear_velocity.x = self.slide_direction.x * slide_speed
		skill_owner.linear_velocity.z = self.slide_direction.z * slide_speed
		#skill_owner.linear_velocity.y = 0
		
	#print("slide_direction = ", dash_direction)
