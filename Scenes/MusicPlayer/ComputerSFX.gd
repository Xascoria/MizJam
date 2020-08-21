extends AudioStreamPlayer

func _ready():
	pass # Replace with function body.

var chess_move = load("res://Resources/Sound/SFX/chess_move.wav")
var chess_move_hit_only = load("res://Resources/Sound/SFX/chess_move_hit_only.wav")

func play_sfx(sfx_id: int) -> void:
	match(sfx_id):
		0:
			volume_db = 0
			self.stream = chess_move
			self.play()
		1:
			volume_db = 0
			self.stream = chess_move_hit_only
			self.play()
		2:
			volume_db = -5
			self.stream = load("res://Resources/Sound/SFX/open_cover.wav")
			self.play()
		3:
			volume_db = -5
			self.stream = load("res://Resources/Sound/SFX/close_cover.wav")
			self.play()
		4:
			volume_db = 0
			self.stream = load("res://Resources/Sound/SFX/switch_click.wav")
			self.play()
		5:
			$DelayTimer.start()


func _on_DelayTimer_timeout():
	volume_db = 0
	self.stream = load("res://Resources/Sound/SFX/computer_move.wav")
	
	self.play()
