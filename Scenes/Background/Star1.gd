extends Sprite

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	self.start_blinking()
	
func start_blinking() -> void:
	var duration := 0.5
	
	$Tween.interpolate_property(self, "modulate:a", 1, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, rng.randi_range(0,5))
	$Tween.start()
	
	$Timer.wait_time = rng.randi_range(3,10)
	$Timer.start()
	
func _on_Timer_timeout():
	var duration := 0.5
	
	if self.modulate.a > 0.5:
		$Tween.interpolate_property(self, "modulate:a", 1, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	else:
		$Tween.interpolate_property(self, "modulate:a", 0, 1, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	
	$Tween.start()
	$Timer.wait_time = rng.randi_range(3,10)
	$Timer.start()
