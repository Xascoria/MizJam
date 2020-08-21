extends Node2D

func _ready():
	$Panel/paragraph1.visible_characters = 0
	$Panel/Button.visible = false
	$Panel/credit.visible = false
	self.load_text()

func load_text():
	$Tween.interpolate_property($Panel/paragraph1, "visible_characters", 0, len($Panel/paragraph1.text),
	len($Panel/paragraph1.text)/14.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.5)
	$Tween.start()

func _on_Tween_tween_all_completed():
	$Timer.start()

func _on_Timer_timeout():
	$Panel/Button.visible = true
	$Panel/credit.visible = true

func _on_Button_pressed():
	self.get_tree().change_scene("res://Scenes/OpeningScene/OpeningScene.tscn")
