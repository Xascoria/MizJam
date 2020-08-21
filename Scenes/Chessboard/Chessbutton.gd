extends Node2D

var character := "A"
#[x,y]
var grid_position := Vector2(-1,-1)

func _ready():
	pass # Replace with function body.

func setup(new_char: String, region_rect: Vector2, index: int):
	self.character = new_char
	$Sprite.region_rect = Rect2(region_rect, Vector2(16,16))
	
	if index % 2 != 0:
		$Sprite.modulate = Color(0,0,0)
	self.grid_position = Vector2(index%5, index/5)

signal button_pressed(char_code, grid_pos)
func _on_Button_pressed():
	emit_signal("button_pressed", character, grid_position)

func animate_movement(start_pos: Vector2) -> void:
	$PieceNode.get_child(0).position = ((start_pos - grid_position) * 32)
	
	var duration = 0.75
	$Tween.interpolate_property($PieceNode.get_child(0), "position", $PieceNode.get_child(0).position, Vector2(0,0), duration)
	$Tween.start()
	
	
