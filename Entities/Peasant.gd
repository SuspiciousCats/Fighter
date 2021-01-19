extends CharacterBase

export (float) var specialAttackDamage: float = 50

onready var specialAttackSoundPlayer: AudioStreamPlayer2D = get_node("SpecialAttackSoundPlayer")

onready var specialAttackDamageTimer: Timer = get_node("SpecialAttackDamageTimer")


func _is_of_enemy_type(body) -> bool:
	return body is CharacterBase


func _activate_special_attack():
	if specialAttackChargeAmount >= 100:
		specialAttackChargeAmount = 0
		if specialAttackSoundPlayer != null:
			specialAttackSoundPlayer.play()

		doingSpecialAttack = true
		shouldUpdateAnimation = false;
		animatedSprite.animation = "SpecialAttack"

		#setup attack timer
		specialAttackDamageTimer = Timer.new()
		specialAttackDamageTimer.connect("timeout", self, "_deal_special_attack_damage")
		specialAttackDamageTimer.wait_time = 0.13
		add_child(specialAttackDamageTimer)
		specialAttackDamageTimer.start()
	pass


func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "SpecialAttack" && doingSpecialAttack:
		doingSpecialAttack = false
		shouldUpdateAnimation = true;
	pass  # Replace with function body.


func _deal_special_attack_damage():
	if damageArea != null:
		var bodies = damageArea.get_overlapping_bodies()
		for body in bodies:
			if _is_of_enemy_type(body) && body != self:
				body.call("on_damage", specialAttackDamage, self)
			pass
	specialAttackDamageTimer.stop()
	pass
