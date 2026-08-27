class_name Interactable
extends StaticBody3D

@export var is_interactable : bool :
	set(new_value) :
		if new_value:
			self.add_to_group("Interactable")
		elif self.is_in_group("Interactable"):
			self.remove_from_group("Interactable")
		is_interactable = new_value
