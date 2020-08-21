extends Node2D

enum PIECETYPE {ROOK, BISHOP, KNIGHT, KING, QUEEN}
export(PIECETYPE) var type := 0
onready var piece = $Piece

func _ready():
	$Piece.visible = false
	var piece_type := "test"
	match(type):
		0:
			piece_type = "rook"
		1:
			piece_type = "bishop"
		2:
			piece_type = "knight"
		3:
			piece_type = "king"
		4:
			piece_type = "queen"
	$Piece.setup(piece_type)

var left_corner_end := 27.2
var right_corner_start := 27.2

func _draw():
	self.draw_rect( Rect2(0, 0 , left_corner_end , 54.4), Color8(246,246,246), true )
	self.draw_rect( Rect2(right_corner_start , 0 , left_corner_end , 54.4), Color8(246,246,246), true )
	
var opening_cover := true
func open_cover():
	var time := 0.6
	
	$Tween.interpolate_property(self, "left_corner_end", 27.2, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.interpolate_property(self, "right_corner_start", 27.2, 54.4, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.interpolate_method(self, "update_cover", 0, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.start()
	
	opening_cover = true
	
	$Timer.wait_time = 0.4
	$Timer.start()

func _on_Timer_timeout():
	if not $Piece:
		print("Phantom bug triggered")
	$Piece.visible = opening_cover
	
func close_cover():
	$Timer.wait_time = 0.1
	$Timer.start()
	
	var time := 0.3
	
	$Tween.interpolate_property(self, "left_corner_end", 0, 27.2, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.interpolate_property(self, "right_corner_start", 54.4, 27.2, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$Tween.interpolate_method(self, "update_cover", 0, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	
	if not $Piece:
		print("Phantom bug triggered")
	$Piece/MoveCounter.visible = false
	
	opening_cover = false
	
	$Tween.start()
	
func update_cover(_arg):
	self.update()

signal piece_clicked(piece_ref)
func _on_Piece_piece_clicked(self_ref):
	emit_signal("piece_clicked", self_ref)
	
