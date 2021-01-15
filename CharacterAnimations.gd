extends Node2D;

var animSystem:AnimationPlayer;

# Called when the node enters the scene tree for the first time.
func _ready():
	animSystem = get_node("CharacterAnimations");
	pass # Replace with function body.

func _process(delta):
	if(animSystem.has_animation("Hit") && animSystem.has_animation("Idle")):
		if Input.is_action_pressed("ui_up"):		
			animSystem.play("Hit");
		else:
			animSystem.play("Idle");
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
