tool
extends Node2D

var chess_button := preload("res://Scenes/Chessboard/Chessbutton.tscn")
var button_ref := [
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
]

const letter_loc_dict = {
	"A":Vector2(560,288),
	"B":Vector2(576,288),
	"C":Vector2(592,288),
	"D":Vector2(608,288),
	"E":Vector2(624,288),
	"F":Vector2(640,288),
	"G":Vector2(656,288),
	"H":Vector2(672,288),
	"I":Vector2(688,288),
	"J":Vector2(704,288),
	"K":Vector2(720,288),
	"L":Vector2(736,288),
	"M":Vector2(752,288),
	"N":Vector2(560,304),
	"O":Vector2(576,304),
	"P":Vector2(592,304),
	"Q":Vector2(608,304),
	"R":Vector2(624,304),
	"S":Vector2(640,304),
	"T":Vector2(656,304),
	"U":Vector2(672,304),
	"V":Vector2(688,304),
	"W":Vector2(704,304),
	"X":Vector2(720,304),
	"Y":Vector2(736,304),
}

func _ready():
	self.import_letters()

func _draw():
	#Draw chessboard
	for i in range(5):
		for j in range(5):
			self.draw_rect(Rect2(i*32, j*32, 32, 32), 
			Color8(37,37,42) if (i+j)%2 == 0 else Color.white, true)

func import_letters() -> void:
	var list_of_letters := "ABCDEFGHIJKLMNOPQRSTUVWXY"
	var index := 0
	
	for i in list_of_letters:
		var new_button = chess_button.instance()
		new_button.setup(i, letter_loc_dict[i], index)
		new_button.connect("button_pressed", self, "on_button_pressed")
			
		$Letters.add_child(new_button)
		new_button.position = Vector2((index%5) * 32, (index/5) * 32)
		button_ref[index/5][index%5] = new_button
			
		index += 1

signal tile_clicked(character, grid_pos)
func on_button_pressed(button_char: String, grid_pos: Vector2) -> void:
	emit_signal("tile_clicked", button_char, grid_pos)

func add_piece(grid_pos: Vector2, ref_to_piece) -> void:
	ref_to_piece.scale = Vector2(1, 1)
	button_ref[grid_pos[1]][grid_pos[0]].get_node("PieceNode").add_child(ref_to_piece)
	ref_to_piece.position = Vector2(0,0)

func set_predictions(available_sqrts: Array) -> void:
	for i in available_sqrts:
		$TileMap.set_cellv(i, 0)

func reset_predictions() -> void:
	for i in $TileMap.get_used_cells():
		$TileMap.set_cellv(i, -1)
