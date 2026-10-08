class_name DashSkill
extends CharacterSkill

@export var dash_speed: float = 50
## divides the dash speed by the amount
@export var dash_damp: float = 8 
var dash_direction: Vector3 = Vector3(0,0,-1)
#TODO : la direccion no jala bien
#@export var jump_skill: JumpSkill
#var timer : float = 0.0
#var timer_wait_time : float = 0.5


func _ready() -> void:
	skill_ready()
	print(skill_duration_wait_time)
	#skill_finished.connect(_on_dash_skill_finished)

func _physics_process(delta: float) -> void:
	skill_physics_process(delta)
	if is_skill_active :
		skill_owner.linear_velocity = dash_direction * dash_speed
		#print(skill_duration_wait_time)

#func _on_dash_skill_finished(skill_instance: CharacterSkill):
	#pass
	#print(self, "skill_finished")
	#print("is ", skill_instance, "equal to ", self," = ", skill_instance == self)
	#skill_owner.linear_velocity = dash_direction * (dash_speed / dash_damp)
	#skill_owner.linear_velocity = Vector3.ZERO
	#skill_owner.apply_central_impulse(dash_direction * (dash_speed / dash_damp))
	#skill_owner.apply_central_impulse(dash_direction * dash_speed)
	#skill_owner.linear_velocity = Vector3.ZERO
