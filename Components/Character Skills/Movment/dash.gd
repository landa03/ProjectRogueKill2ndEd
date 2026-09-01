#TODO : dash
#	stamina
#		costo, current & max
#	timeline
#		duration
#	last direction input
#	dash speed

extends CharacterSkill

@export var dash_speed : float
var dash_direction: Vector3 = Vector3(0,0,-1)

func _physics_process(delta: float) -> void:
	if self.is_skill_active :
		self.skill_current_duration
