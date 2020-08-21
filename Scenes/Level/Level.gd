#Controlling the level flow

extends Node2D

var dialog_pointer := 0
#Format: box size, text, trigger level
var dialogs = {
	0: [1, "Hello there.", false],
	1: [3, "Bio-scanner has identified you \nas a “human”.", false],
	2: [3, "I see our \nspecies has yet \nto meet.", false],
	3: [3, "My name is \nAirocsax, from \nthe planet Xien.", false],
	4: [4, "Are you stranded here?", false],
	5: [5, "Mmph mmmph.", false],
	6: [3, "I don’t think your garment allows you to speak in vacuum.", false],
	7: [1, "Um...", false],
	8: [2, "Wait, I have an idea.", false],
	9: [2, "Here, have this.", true],
	10: [4, "It’s a “human computer” I made.", false],
	11: [6, "Based on the information from \na Golden Circle \nwe found.", false],
	12: [4, "I’ll explain how \nit works:", false],
	13: [3, "Hover over a chess piece, there will be numbers on top", true],
	14: [3, "Placing the piece on the board starts the counter,", true],
	15: [3, "which would count down with each move made.", false],
	16: [6, "When the number reached 0, the letter it is standing on will be typed.", false],
	17: [3, "Then, the counter will be set to the next number in line.", false],
	18: [3, "I’ll ask you some question, type out your response on it.", true],
	19: [4, "So, do you \nneed help?", true],
	20: [5, "SOS", false],
	21: [2, "Understood.", false],
	22: [4, "Judging by your clumsy movement,", false],
	23: [6, "I’m assuming that this is not a very accurate computer of your kind.", false],
	24: [6, "What's the name of the inventor of computer on your planet?", false],
	25: [6, "I will try and look up a proper human computer in my database.", true],
	26: [5, "TURING", false],
	27: [2, "Let me look it up.", false],
	28: [4, "Huh, nothing \ncame up.", false],
	29: [6, "Well, I guess I’ll \njust bring you back to your home \nplanet then.", false],
	30: [4, "What galaxy are \nyou from?", true],
	31: [5, "MILKYWAY", false],
	32: [6, "Let me look up planets that fit your home planet \nin that galaxy.", false],
	33: [1, "...", false],
	34: [4, "There’re several hundreds hits.", false],
	35: [6, "Can you tell me a \nstar system that \nis close to your \nhome system?", true],
	36: [5, "ALPHACENTAURI", false],
	37: [2, "I found a match.", false],
	38: [4, "Okay, follow me \nto my ship.", false],
	39: [4, "Anything else before we leave?", true],
	40: [5, "THANKYOU", true],
	41: [4, "It's... it's no big \ndeal!!! (>_<''')", true],
	42: [4, "Just... just get \ngoing ok?! (=v=)", true],
	
}

var size1_dialog := load("res://Scenes/DialogBoxes/size1.tscn")
var size2_dialog := load("res://Scenes/DialogBoxes/size2.tscn")
var size3_dialog := load("res://Scenes/DialogBoxes/size3.tscn")
var size4_dialog := load("res://Scenes/DialogBoxes/size4.tscn")
var size5left_dialog := load("res://Scenes/DialogBoxes/size5left.tscn")
var size6_dialog := load("res://Scenes/DialogBoxes/size6.tscn")

func _ready():
	BgmPlayer.change_song(1)
	if not GlobalVars.testing:
		dialog_pointer = 0
	#These are for testing only
	if dialog_pointer < 8:
		$Computer.position = Vector2(0,368)
	else:
		validating_ans = true

func _on_DialogTimer_timeout():
	var new_dialog_box
	var dialog_pos := Vector2(0,0)
	if dialogs.has(dialog_pointer):
		match(dialogs[dialog_pointer][0]):
			1:
				new_dialog_box = size1_dialog.instance()
				dialog_pos = Vector2(221,102)
			2:
				new_dialog_box = size2_dialog.instance()
				dialog_pos = Vector2(221,102)
			3:
				new_dialog_box = size3_dialog.instance()
				dialog_pos = Vector2(221, 73.5)
			4:
				new_dialog_box = size4_dialog.instance()
				dialog_pos = Vector2(221, 88.3)
			5: 
				new_dialog_box = size5left_dialog.instance()
				dialog_pos = Vector2(14, 104)
			6:
				new_dialog_box = size6_dialog.instance()
				dialog_pos = Vector2(221, 61.4)
				
		new_dialog_box.setup(dialogs[dialog_pointer][1])
		new_dialog_box.scale = Vector2(1.5,1.5)
		$Background.auto_fade = true
		
		if dialogs[dialog_pointer][2]:
			var trigger =  self.trigger_event(dialog_pointer)
			if trigger:
				$Background.auto_fade = false
				$DialogTimer.paused = true
		
		$Background.add_dialog(new_dialog_box, dialog_pos)

var solution := "NULL"
var validating_ans := false

func trigger_event(chat_id: int):
	match(chat_id):
		9:
			$Tween.interpolate_property($Computer, "position", Vector2(0,368), Vector2(0,0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2)
			$Tween.start()
			ComputerSfx.play_sfx(5)
			return false
		13:
			$Computer.operations_dict["pick_up_piece"] = true
			$Computer.setting_moves([ [0], [2,2,4], [0], [0], [0] ])
			return false
		14:
			$Computer.operations_dict["placing_piece"] = true
			return false
		18:
			$Computer.operations_dict["reset"] = true
			return false
		19:
			$Background.auto_fade = false
			solution = "SOS"
			validating_ans = true
			$Background.show_answer_think(solution)
		25:
			$Background.auto_fade = false
			solution = "TURING"
			$Background.show_answer_think(solution)
			$Computer.setting_moves([ [1,2,1], [0], [1,2,1], [0], [0] ])
			$Computer.operations_dict["reset"] = true
			$Computer.set_hint_content("Order in which the letters are typed:\nBishop, Rook, Bishop, Rook, Bishop, Rook")
		30:
			$Background.auto_fade = false
			solution = "MILKYWAY"
			$Background.show_answer_think(solution)
			$Computer.setting_moves([ [2,2,1], [1,3],[0],[1,1,1],[0], ])
			$Computer.operations_dict["reset"] = true
			$Computer.set_hint_content("Order in which the letters are typed:\nQueen, Bishop, Knight, Queen, Bishop, Queen, Bishop, Knight")
		35:
			$Background.auto_fade = false
			solution = "ALPHACENTAURI"
			$Background.show_answer_think(solution)
			$Computer.setting_moves([ [1,2,2], [1,1,1,4], [1,1], [0], [1,2,2,1] ])
			$Computer.operations_dict["reset"] = true
			$Computer.set_hint_content("Order in which the letters are typed:\nKnight, Bishop, Rook, Knight, King, King, Knight, King, Bishop, Rook, Knight, Bishop, King")
		39:
			$Background.auto_fade = false
			solution = "THANKYOU"
			$Background.show_answer_think(solution)
			$Computer.setting_moves([ [1],[2,1],[1,1],[1,1],[1], ])
			$Computer.operations_dict["reset"] = true
			$Computer.set_hint_content("Order in which the letters are typed:\nBishop, King, Rook, Knight, Queen, Knight, Queen, Rook")
		40:
			BgmPlayer.change_song(2)
			return false
		41:
			$Background.show_blushes()
			return false
		42:
			$Background.flip_human()
			$Tween.interpolate_property($Computer, "position", Vector2(0,0), Vector2(0,368), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2)
			$Tween.start()
			return false
			
	return true
	
func _on_Computer_text_changed(answer):
	if validating_ans:
		if answer == solution:
			$Background.level_finished()
			$FinishTimer.start()
	$DialogTimer.paused = false
			
func _on_FinishTimer_timeout():
	$Computer.finish_level()
	
func _on_Background_dialogue_shown():
	dialog_pointer += 1
	$DialogTimer.start()




