extends KinematicBody2D

class_name CharacterBase

export (float) var gravityForce = 9800

export (float) var jumpForce = -4500

export (float) var velocityCheckErrorTolerance = 0.01

export (bool) var controlledByPlayer = true

export (float) var speed = 3000

var damageArea: Area2D

var animatedSprite: CharacterAnimationManager

var velocity = Vector2.ZERO

var blocking: bool = false

var attacking: bool = false

#timers

#How long is attack anim
var attackAnimTimer: Timer

#When to attack during attack anim
var attackTimer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite = get_node("AnimatedSprite")
	attackAnimTimer = get_node("AttackAnimTimer")
	attackTimer = get_node("AttackTimer")
	damageArea = get_node("DamageArea2D")
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _update_animation():
	if abs(velocity.x - 0) > velocityCheckErrorTolerance && animatedSprite != null:
		if velocity.x > 0:
			animatedSprite.scale.x = 1
			damageArea.scale.x = 1
		if velocity.x < 0:
			animatedSprite.scale.x = -1
			damageArea.scale.x = -1

	if velocity.x != 0 && velocity.y == 0:
		animatedSprite.animation = "Run"
	if velocity.y != 0 && velocity.x == 0:
		if velocity.y < 0:
			animatedSprite.animation = "Jump"
		else:
			animatedSprite.animation = "Fall"
	if velocity == Vector2.ZERO && ! attacking:
		if blocking:
			animatedSprite.animation = "Block_Idle"
		else:
			animatedSprite.animation = "Idle"

	if attacking:
		animatedSprite.animation = "Attack"

	if ! animatedSprite.playing:
		animatedSprite.play()
	pass


func _prcocess_input(delta):
	if controlledByPlayer:
		if Input.is_action_pressed("ui_left"):
			velocity.x = speed * -1
		elif Input.is_action_pressed("ui_right"):
			velocity.x = speed
		else:
			velocity.x = 0

		if Input.is_action_pressed("block"):
			blocking = true
		else:
			blocking = false

		if Input.is_action_pressed("attack") && ! attacking:
			#setup attack anim timer
			attackAnimTimer = Timer.new()
			attackAnimTimer.connect("timeout", self, "_on_attack_timer_over")
			attackAnimTimer.wait_time = animatedSprite.attackAnimationLenght
			add_child(attackAnimTimer)
			attackAnimTimer.start()

			attacking = true

			#setup attack timer
			attackTimer = Timer.new()
			attackTimer.connect("timeout", self, "_attack")
			attackTimer.wait_time = animatedSprite.attackAnimationAttackTime
			add_child(attackTimer)
			attackTimer.start()

	pass


func _physics_process(delta):
	_prcocess_input(delta)

	velocity.y += gravityForce * delta

	velocity = move_and_slide(velocity * delta, Vector2.UP)

	if Input.is_action_pressed("ui_up") && is_on_floor():
		velocity.y = jumpForce

	_update_animation()
	pass


func _on_attack_timer_over():
	attacking = false
	attackAnimTimer.stop()
	pass

func on_damage(var damage:int):
	print(damage);
	pass


func _attack():
	if damageArea != null:
		var bodies = damageArea.get_overlapping_bodies();
		for body in bodies :
			if(body is get_script()) && body != self:
				body.call("on_damage",10);
			pass
	attackTimer.stop();
	pass
