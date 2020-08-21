extends Node2D

onready var corners_pos = $Box/Corners.position
onready var edges_pos = $Box/Edges.position
onready var panel_pos = $Box/Panel.rect_position
onready var label_pos = $Label.rect_position

func _ready():
	pass # Replace with function body.

var counter := 5
var altidude := 2
func _physics_process(delta):
	$Box/Corners.position = corners_pos + Vector2(0, sin(deg2rad(counter)) * altidude)
	$Box/Edges.position = edges_pos + Vector2(0, sin(deg2rad(counter)) * altidude)
	$Box/Panel.rect_position = panel_pos + Vector2(0, sin(deg2rad(counter)) * altidude)
	$Label.rect_position = label_pos + Vector2(0, sin(deg2rad(counter)) * altidude)
	
	counter += 5
	if counter == 360:
		counter = 0
