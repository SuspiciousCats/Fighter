extends CharacterBase

var isThrowing = false;

onready var spearScene = preload("res://Entities/Spear.tscn");

onready var spearSpawnPosRight = get_node("DamageArea2D/SpearSpawnPosRight");

onready var spearSpawnPosLeft = get_node("DamageArea2D/SpearSpawnPosLeft");

func _activate_special_attack():
	if specialAttackChargeAmount >= 100:
		specialAttackChargeAmount = 0;
		shouldUpdateAnimation = false;
		animatedSprite.animation = "Throw";
		isThrowing = true;
	pass

func _is_of_enemy_type(body) -> bool:
	return body is CharacterBase;


func _on_AnimatedSprite_animation_finished():
	if isThrowing:
		var spear = spearScene.instance();
		get_parent().add_child(spear);
		spear.owningHuntress = self;
		spear.initialVelocity.x = desiredXScale;
		spear.scale.x = desiredXScale;
		spear.position = (spearSpawnPosRight.position if desiredXScale == 1 else spearSpawnPosLeft.position) + position;
		shouldUpdateAnimation = true;
		isThrowing = false;
	pass # Replace with function body.
