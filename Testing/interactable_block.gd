extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready():
	is_interactable = true
	print(self, " is_interactable = ",is_interactable)
