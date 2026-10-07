class_name JumpSkill
extends CharacterSkill

@export var jump_strength: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if self.is_skill_active:
		#skill_owner.apply_central_impulse(Vector3(0,jump_strength,0))

func _ready():
	skill_ready()
	skill_activated.connect(_on_skill_activated)
	#skill_finished.disconnect(_on_dash_skill_finished)

func _on_skill_activated(skill_instance: CharacterSkill) -> void:
	print(self, "activated")
	#print(self.current_use_charges)
	#current_use_charges -= 1
	if skill_instance == self:
		skill_owner.apply_central_impulse(Vector3(0,jump_strength,0))
