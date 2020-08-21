extends Node2D

var selected_piece = null
var allowed_spots := []
var pieces_locations = [
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
	[null,null,null,null,null,],
]
var initial_piece_moveset := []
onready var chessboard = $Panel/InnerPanel/Chessboard/Root

var operations_dict = {
	"reset":false,
	"pick_up_piece":false,
	"placing_piece":false
}

#For testing only
#var operations_dict = {
#	"reset":true,
#	"pick_up_piece":true,
#	"placing_piece":true
#}

func _ready():
	$Panel/InnerPanel/Label.text = ""
	#Order: Bishop, Knight, Rook, Queen, King
	#Level: SOS, TURING, MILKYWAY, ALPHACENTAURI, THANKYOU
	#TESTING: [ [9],[9],[9],[9],[9], ]
	#SOS: [ [0], [1,2,4], [0], [0], [0] ]
	#TURING: [ [1,2,1], [0], [1,2,1], [0], [0] ]
	#MILKYWAY: [ [2,2,1],[1,3],[0],[1,1,1],[0], ] # QBKQBQBK
	#ALPHACENTURI: [ [1,2,2], [1,1,1,4], [1,1], [0], [1,2,2,1] ]
	#THANKYOU: 
	
	#Testing
	#self.setting_moves([ [1],[2,1],[1,1],[1,1],[1], ])
	if GlobalVars.testing:
		operations_dict = {
			"reset":true,
			"pick_up_piece":true,
			"placing_piece":true
		}
	

func _on_Reset_mouse_entered():
	$Panel/InnerPanel/Reset/Sprite.region_rect = Rect2(64, 16, 16, 16)

func _on_Reset_mouse_exited():
	$Panel/InnerPanel/Reset/Sprite.region_rect = Rect2(48, 16, 16, 16)

func _on_Reset_pressed():
	if not operations_dict["reset"]:
		return
		
	ComputerSfx.play_sfx(4)
	ComputerSfx.play_sfx(3)
	
	for i in range(len(pieces_locations)):
		for j in range(len(pieces_locations[i])):
			if pieces_locations[i][j]:
				var piece = chessboard.button_ref[i][j].get_node("PieceNode").get_child(0)
				match(piece.type):
					"rook":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot3.add_child(piece)
						piece.setup_moves(initial_piece_moveset[2].duplicate())
					"bishop":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot1.add_child(piece)
						piece.setup_moves(initial_piece_moveset[0].duplicate())
					"queen":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot4.add_child(piece)
						piece.setup_moves(initial_piece_moveset[3].duplicate())
					"king":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot5.add_child(piece)
						piece.setup_moves(initial_piece_moveset[4].duplicate())
					"knight":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot2.add_child(piece)
						piece.setup_moves(initial_piece_moveset[1].duplicate())
				
				piece.scale = Vector2(1.7,1.7)
				piece.on_board = false
				piece.grid_pos = Vector2(-1,-1)
				pieces_locations[i][j] = null

#	for i in $Panel/InnerPanel/PiecePanel.get_children():
#		if i.piece.move_counter[0] != 0:
#			i.close_cover()

	for i in range(len(initial_piece_moveset)):
		if initial_piece_moveset[i][0] != 0:
			match(i):
				0:
					$Panel/InnerPanel/PiecePanel/Slot1.close_cover()
				1:
					$Panel/InnerPanel/PiecePanel/Slot2.close_cover()
				2:
					$Panel/InnerPanel/PiecePanel/Slot3.close_cover()
				3:
					$Panel/InnerPanel/PiecePanel/Slot4.close_cover()
				4:
					$Panel/InnerPanel/PiecePanel/Slot5.close_cover()
				
	$Panel/InnerPanel/Label.text = ""
	chessboard.reset_predictions()
	selected_piece = null
	allowed_spots = []
	
	$ResetTimer.start()
	
func _on_ResetTimer_timeout():
	ComputerSfx.play_sfx(2)
	for i in $Panel/InnerPanel/PiecePanel.get_children():
		if i.piece.move_counter[0] != 0:
			i.open_cover()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		selected_piece = null
		allowed_spots = []
		chessboard.reset_predictions()

func _on_Slot_piece_clicked(piece_ref):
	
	allowed_spots = []
	chessboard.reset_predictions()
	
	if not operations_dict["pick_up_piece"]:
		return
	
	selected_piece = piece_ref

	#Disallow movement if it ran out of moves
	if selected_piece.move_counter[0] == 0:
		return
	
	if not selected_piece.on_board:
		var empty_spaces := []
		for i in range(len(pieces_locations)):
			for j in range(len(pieces_locations[i])):
				if not pieces_locations[i][j]:
					empty_spaces.append(Vector2(j,i))
		allowed_spots = empty_spaces
		chessboard.set_predictions(empty_spaces)
	else:
		allowed_spots = calculate_allowed_spots(selected_piece.type)
		chessboard.set_predictions(allowed_spots)

func calculate_allowed_spots(type: String) -> Array:
	var output = []
	
	match(type):
		"rook":
			var coord = selected_piece.grid_pos
			for i in [Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]:
				while true:
					coord += i
					if not in_bound(coord):
						break
					if pieces_locations[coord[1]][coord[0]]:
						break
					output.append(coord)
				coord = selected_piece.grid_pos

		"bishop":
			var coord = selected_piece.grid_pos
			for i in [Vector2(-1,-1), Vector2(1,1), Vector2(1,-1), Vector2(-1,1)]:
				while true:
					coord += i
					if not in_bound(coord):
						break
					if pieces_locations[coord[1]][coord[0]]:
						break
					output.append(coord)
				coord = selected_piece.grid_pos
		"queen":
			var coord = selected_piece.grid_pos
			for i in [Vector2(-1,-1), Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]:
				while true:
					coord += i
					if not in_bound(coord):
						break
					if pieces_locations[coord[1]][coord[0]]:
						break
					output.append(coord)
				coord = selected_piece.grid_pos
		#Done
		"king":
			for i in [-1,0,1]:
				for j in [-1,0,1]:
					if not (i == 0 and j == 0):
						if in_bound(Vector2(i,j) + selected_piece.grid_pos) and \
						not pieces_locations[j + selected_piece.grid_pos[1]][i + selected_piece.grid_pos[0]]:
							output.append(Vector2(i,j) + selected_piece.grid_pos)
		#Done
		"knight":
			for i in [1,-1]:
				for j in [2,-2]:
					if in_bound(Vector2(i,j) + selected_piece.grid_pos) and \
					not pieces_locations[j + selected_piece.grid_pos[1]][i + selected_piece.grid_pos[0]]:
						output.append(Vector2(i,j) + selected_piece.grid_pos)
					if in_bound(Vector2(j,i) + selected_piece.grid_pos) and \
					not pieces_locations[i + selected_piece.grid_pos[1]][j + selected_piece.grid_pos[0]]:
						output.append(Vector2(j,i) + selected_piece.grid_pos)
	
	return output
	
func in_bound(coord: Vector2) -> bool:
	return coord[0] >= 0 and coord[0] < 5 and coord[1] >= 0 and coord[1] < 5

signal text_changed(answer)
func _on_Root_tile_clicked(character, grid_pos):
	
	if selected_piece and grid_pos in allowed_spots and operations_dict["placing_piece"]:	
		if in_bound(selected_piece.grid_pos):
			ComputerSfx.play_sfx(0)
			pieces_locations[selected_piece.grid_pos[1]][selected_piece.grid_pos[0]] = null
		else:
			ComputerSfx.play_sfx(1)
		
		if selected_piece.make_a_move() and selected_piece.on_board:
			self.add_text(character)
			emit_signal("text_changed", $Panel/InnerPanel/Label.text)
		
		selected_piece.get_parent().remove_child(selected_piece)
		chessboard.add_piece(grid_pos, selected_piece)
		if selected_piece.on_board:
			chessboard.button_ref[grid_pos[1]][grid_pos[0]].animate_movement(selected_piece.grid_pos)
		
		selected_piece.on_board = true
		selected_piece.grid_pos = grid_pos
		pieces_locations[grid_pos[1]][grid_pos[0]] = selected_piece.type

		allowed_spots = []
		chessboard.reset_predictions()
		selected_piece = null
		
		
#Order: Bishop, Knight, Rook, Queen, King
func setting_moves(moveset: Array) -> void:
	initial_piece_moveset = moveset.duplicate(true)
	
	$Panel/InnerPanel/PiecePanel/Slot1/Piece.setup_moves(moveset[0])
	$Panel/InnerPanel/PiecePanel/Slot2/Piece.setup_moves(moveset[1])
	$Panel/InnerPanel/PiecePanel/Slot3/Piece.setup_moves(moveset[2])
	$Panel/InnerPanel/PiecePanel/Slot4/Piece.setup_moves(moveset[3])
	$Panel/InnerPanel/PiecePanel/Slot5/Piece.setup_moves(moveset[4])
	
	ComputerSfx.play_sfx(2)
	for i in range(len(moveset)):
		var ref_to_slot = "Panel/InnerPanel/PiecePanel/Slot" + str(i+1) + "/Piece"
		self.get_node(ref_to_slot).setup_moves(moveset[i])
		if moveset[i][0] != 0:
			self.get_node(ref_to_slot.substr(0, len(ref_to_slot)-6)).open_cover()
	
func add_text(new_char: String):
	$Panel/InnerPanel/Label.text += new_char

func finish_level():
	for i in range(len(pieces_locations)):
		for j in range(len(pieces_locations[i])):
			if pieces_locations[i][j]:
				var piece = chessboard.button_ref[i][j].get_node("PieceNode").get_child(0)
				match(piece.type):
					"rook":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot3.add_child(piece)
						piece.setup_moves(initial_piece_moveset[2].duplicate())
					"bishop":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot1.add_child(piece)
						piece.setup_moves(initial_piece_moveset[0].duplicate())
					"queen":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot4.add_child(piece)
						piece.setup_moves(initial_piece_moveset[3].duplicate())
					"king":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot5.add_child(piece)
						piece.setup_moves(initial_piece_moveset[4].duplicate())
					"knight":
						piece.get_parent().remove_child(piece)
						$Panel/InnerPanel/PiecePanel/Slot2.add_child(piece)
						piece.setup_moves(initial_piece_moveset[1].duplicate())
				
				piece.scale = Vector2(1.7,1.7)
				piece.on_board = false
				piece.grid_pos = Vector2(-1,-1)
				pieces_locations[i][j] = null
		
	ComputerSfx.play_sfx(3)
	for i in range(len(initial_piece_moveset)):
		if initial_piece_moveset[i][0] != 0:
			match(i):
				0:
					$Panel/InnerPanel/PiecePanel/Slot1.close_cover()
				1:
					$Panel/InnerPanel/PiecePanel/Slot2.close_cover()
				2:
					$Panel/InnerPanel/PiecePanel/Slot3.close_cover()
				3:
					$Panel/InnerPanel/PiecePanel/Slot4.close_cover()
				4:
					$Panel/InnerPanel/PiecePanel/Slot5.close_cover()
				
	$Panel/InnerPanel/Label.text = ""
	chessboard.reset_predictions()
	selected_piece = null
	allowed_spots = []
	
	operations_dict["reset"] = false

func _on_Hint_pressed():
	if operations_dict["reset"]:
		ComputerSfx.play_sfx(4)
		$Popup.popup()

func _on_Hint_mouse_entered():
	$Panel/InnerPanel/Hint/Sprite.region_rect = Rect2(96,16,16,16)

func _on_Hint_mouse_exited():
	$Panel/InnerPanel/Hint/Sprite.region_rect = Rect2(80,16,16,16)

func set_hint_content(new_content: String) -> void:
	$Popup/BackPanel/TruePanel/Content.text = new_content
	
func _on_Popup_about_to_show():
	$Panel/InnerPanel/Chessboard.visible = false

func _on_Popup_popup_hide():
	$Panel/InnerPanel/Chessboard.visible = true
