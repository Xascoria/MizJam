extends Node2D

var move_counter := PoolIntArray([0,0])
var type := "placeholder"
var on_board := false
var grid_pos := Vector2(-1,-1)

func _ready():
	$MoveCounter.visible = false

func setup(type: String):
	var offset := 16
	self.type = type
	match(type):
		"rook":
			offset = 16
		"bishop":
			offset = 32
		"queen":
			offset = 48
		"king":
			offset = 64
		"knight":
			offset = 80
	$piece.region_rect = Rect2(offset,0,16,16)
	
func setup_moves(moves: PoolIntArray) -> void:
	move_counter = moves
	
	self.refresh_moves()
		
func refresh_moves():
	$MoveCounter/MainMove.region_rect = Rect2(Vector2(move_counter[0] * 16, 16), Vector2(16,16))
	
	for i in $MoveCounter.get_children():
		if i.name != "MainMove":
			i.queue_free()
	
	var start_of_lower_num := (32 - (8 * (len(move_counter) - 1)))/2
	
	for i in range(1, len(move_counter)):
		var new_num = Sprite.new()
		new_num.texture = load("res://Resources/Custom/pieces.png")
		new_num.centered = false
		new_num.region_enabled = true
		new_num.region_rect = Rect2(move_counter[i] * 16,16,16,16)
		new_num.scale = Vector2(0.5,0.5)
		
		$MoveCounter.add_child(new_num)
		new_num.position = Vector2(start_of_lower_num, -8)
		start_of_lower_num += 8

signal piece_clicked(self_ref)

func _on_Button_mouse_entered():
	$MoveCounter.visible = true

func _on_Button_mouse_exited():
	$MoveCounter.visible = false

func _on_Button_pressed():
	emit_signal("piece_clicked", self)

func make_a_move() -> bool:
	if on_board and move_counter[0] != 0:
		move_counter[0] -= 1
	
	if move_counter[0] == 0:
		if len(move_counter) != 1:
			move_counter.remove(0)
		self.refresh_moves()
		return true
	self.refresh_moves()
	return false
	


