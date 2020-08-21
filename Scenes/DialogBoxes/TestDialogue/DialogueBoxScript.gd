extends Node2D

onready var label = $Label

func _ready():
	pass

func setup(new_text: String) -> void:
	$Label.text = new_text
