extends Area2D

export (float) var speed: float = 200

export (int) var damage: int = 30

var owningHuntress: CharacterBase

export (Vector2) var initialVelocity: Vector2 = Vector2(1, 0)


func _physics_process(delta):
	position.x += initialVelocity.x * speed * delta
	pass


func _on_Spear_body_entered(body):
	if (body is CharacterBase) && body != owningHuntress:
		(body as CharacterBase).on_damage(damage, owningHuntress)
		queue_free();
	pass  # Replace with function body.
