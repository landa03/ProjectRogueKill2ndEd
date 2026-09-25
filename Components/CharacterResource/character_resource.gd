class_name CharacterResource
extends Node

signal resource_amount_changed(old_value, new_value)

@export var max_resource_amount : float = 100
var curent_resource_amount : float
#var curent_resource_amount : float = max_resource_amount :
	#set(new_value) : 
		#resource_amount_changed.emit(curent_resource_amount,new_value)
		#curent_resource_amount = clamp(new_value, 0, max_resource_amount)

@export var change_rate : float = 0 #how much it passively changes
@export var should_recharge: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	resource_amount_changed.connect(_on_resource_amount_changed)
	curent_resource_amount = max_resource_amount

func _on_resource_amount_changed(old_value, new_value):
	curent_resource_amount = clamp(new_value, 0, max_resource_amount)
	#print(old_value, new_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if should_recharge:
		curent_resource_amount += change_rate * delta
	if curent_resource_amount < max_resource_amount:
		print(curent_resource_amount)
