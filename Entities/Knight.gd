extends CharacterBase

onready var specialAttackTimer:Timer = get_node("SpecialAttackShieldTime");
export (float) var specialAttackShieldTime:float = 1;

#knight's special attack is weird one, because it's not even an attack
#it's basically block that is being created for a few seconds and then reset
func _activate_special_attack():
	if specialAttackChargeAmount >= 100 && specialAttackTimer != null && !blocking:
		blocking = true;
		specialAttackTimer = Timer.new();
		specialAttackTimer.connect("timeout",self,"_stop_special_attack");
		specialAttackTimer.wait_time = specialAttackShieldTime;
		add_child(specialAttackTimer);
		specialAttackTimer.start();
		doingSpecialAttack = true;
	pass

func _stop_special_attack():
	blocking = false;
	specialAttackChargeAmount = 0;
	specialAttackTimer.stop();
	doingSpecialAttack = false;
	pass

func on_damage(damage: int,damager:CharacterBase):
	if !blocking:
		.on_damage(damage,damager);
	else:
		damager.on_damage(damage*0.25,self);
	pass

func _is_of_enemy_type(body) -> bool:
	return body is CharacterBase;
