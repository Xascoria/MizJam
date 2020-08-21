extends Node2D

func _ready():
	if not GlobalVars.first_launch:
		BgmPlayer.change_song(0)
	GlobalVars.first_launch = false
	
	$Panel/paragraph1.visible_characters = 0
	$Panel/paragraph2.visible_characters = 0
	$Panel/paragraph3.visible_characters = 0
	$Panel/Button.visible = false
	$Panel/ScrollingSpeed.visible = false
	
func _on_StartTimer_timeout():
	self.load_text()

var paragraph_ptr := 0
onready var paras = [$Panel/paragraph1, $Panel/paragraph2, $Panel/paragraph3]

func load_text():
	$Tween.interpolate_property(paras[paragraph_ptr], "visible_characters", 0, len(paras[paragraph_ptr].text),
	len(paras[paragraph_ptr].text)/14.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	
	$Tween.start()

func _on_Tween_tween_all_completed():
	paragraph_ptr += 1
	var delay := 1.5
	if paragraph_ptr < len(paras):
		$Tween.interpolate_property(paras[paragraph_ptr], "visible_characters", 0, len(paras[paragraph_ptr].text),
		len(paras[paragraph_ptr].text)/14.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	
		$Tween.start()
	else:
		$Timer.wait_time = 2
		$Timer.start()

func _on_Timer_timeout():
	$Panel/Button.visible = true
	$Panel/ScrollingSpeed.visible = true

func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/Level/Level.tscn")

onready var speed_buttons = [$Panel/ScrollingSpeed/Slow, $Panel/ScrollingSpeed/Average, $Panel/ScrollingSpeed/Fast]
func _on_speed_settings_pressed(extra_arg_0: int):
	for i in range(3):
		speed_buttons[i].pressed = (i == extra_arg_0)
	
	match(extra_arg_0):
		0:
			GlobalVars.scrolling_speed = 16.0
		1:
			GlobalVars.scrolling_speed = 21.0
		2:
			GlobalVars.scrolling_speed = 26.0
	
