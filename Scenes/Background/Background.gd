extends Node2D

var current_dialog
var auto_fade := true

func _ready():
	$DialogBoxes/Think.modulate.a = 0
	
	#self.flip_human()

func _draw():
	pass

func add_dialog(ref_to_dialog, dialog_pos : Vector2) -> void:
	ref_to_dialog.modulate.a = 0
	
	$DialogBoxes.add_child(ref_to_dialog)
	ref_to_dialog.label.set("visible_characters",0)
	
	ref_to_dialog.position = dialog_pos
	$DialogBoxes/Tween.interpolate_property(ref_to_dialog, "modulate:a", 0, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$DialogBoxes/Tween.interpolate_property(ref_to_dialog.label, "visible_characters", 0, len(ref_to_dialog.label.text), 
	len(ref_to_dialog.label.text)/GlobalVars.scrolling_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	
	current_dialog = ref_to_dialog
	
	$DialogBoxes/Tween.start()

signal dialogue_shown
func _on_dialog_shown():
	if auto_fade:
		if current_dialog.modulate.a > 0.5:
			$DialogBoxes/Tween.interpolate_property(current_dialog, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2.5)
			$DialogBoxes/Tween.start()
			emit_signal("dialogue_shown")
		else:
			current_dialog.queue_free()
			
func show_answer_think(new_text:String):
	$DialogBoxes/Think/Label.text = new_text
	
	$DialogBoxes/Think/Tween.interpolate_property($DialogBoxes/Think, "modulate:a", 0, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3)
	$DialogBoxes/Think/Tween.start()
	
func level_finished():
	$DialogBoxes/Think/Tween.interpolate_property($DialogBoxes/Think, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$DialogBoxes/Think/Tween.start()
	
	$DialogBoxes/Tween.interpolate_property(current_dialog, "modulate:a", 1, 0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$DialogBoxes/Tween.start()
	emit_signal("dialogue_shown")
	$QueuefreeTimer.start()
	
func _on_Timer_timeout():
	current_dialog.queue_free()
	
func show_blushes():
	$Ground/Alien/Alien/Blushes/Tween.interpolate_property($Ground/Alien/Alien/Blushes, "modulate:a", 0, 1, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.4)
	$Ground/Alien/Alien/Blushes/Tween.interpolate_property($Ground/Alien/Alien/Blushes, "modulate:a", 1, 0, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 8)
	$Ground/Alien/Alien/Blushes/Tween.start()
	
func flip_human():
	var delay := 5
	
	$Ground/Human/Tween.interpolate_property($Ground/Human/Human, "scale:x", 4, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1 + delay)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "scale:x", 0, 4, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.2 + delay)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "scale", Vector2(4,4), Vector2(1,1), 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1 + delay)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "position:x", 131, 343, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1 + delay)
	#$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "position:y", 189, 221, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "position:y", 189, 187, 1.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1 + delay)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "position:y", 187, 221, 3.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2.5 + delay)
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "rotation_degrees", -5.3, 14, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.1 + delay )
	$Ground/Human/Tween.interpolate_property($Ground/Human/HumanWalk, "modulate:a", 1, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 6.1 - 0.2  + delay)
	
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/Alien, "scale:x", 4, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5 + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "scale:x", 0, 4, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.7 + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "scale", Vector2(4,4), Vector2(1,1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.8  + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "position:x", 249, 343, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.8  + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "position:y", 189, 221, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.8  + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "rotation_degrees", 5.4, 14, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.8  + delay)
	$Ground/Alien/Tween.interpolate_property($Ground/Alien/AlienWalk, "modulate:a", 1, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 3.8 - 0.2  + delay)
	
	$Ground/Human/Tween.start()
	$Ground/Alien/Tween.start()
	
	$UFO/Tween.interpolate_property($UFO, "rotation_degrees", 13.2, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 7.2 + delay)
	$UFO/Tween.interpolate_property($UFO, "position:y", 203, 143, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 7 + delay)
	$UFO/Tween.interpolate_property($UFO, "position:x", 345, -30, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 8.5 + delay)
	
	$UFO/Tween.start()
	
	$SceneChangeTimer.wait_time = 9.5 + delay
	$SceneChangeTimer.start()


func _on_SceneChangeTimer_timeout():
	self.get_tree().change_scene("res://Scenes/EndingScene/EndingScene.tscn")
