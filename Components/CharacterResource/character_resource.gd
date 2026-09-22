class_name CharacterResource
extends Node

#signal resource_amount_changed(old_value, new_value)

@export var max_resource_amount : float = 100
var curent_resource_amount : float = max_resource_amount :
	set(new_value) : 
		#resource_amount_changed.emit(curent_resource_amount, new_value)
		curent_resource_amount = clamp(new_value, 0, max_resource_amount)

@export var change_rate : float = 0 #how much it passively

# Called when the node enters the scene tree for the first time.
#func _ready():


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	curent_resource_amount += change_rate * delta
	if curent_resource_amount < max_resource_amount:
		print(curent_resource_amount)
