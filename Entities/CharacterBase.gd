extends KinematicBody2D


export (float) var gravityForce = 9800;

export (bool) var controlledByPlayer = true;

export (float) var speed  = 3000;

var velocity = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	
	if(controlledByPlayer):
		if Input.is_action_pressed("ui_left"):
			velocity.x = speed * -1;
		elif  Input.is_action_pressed("ui_right"):
			velocity.x = speed;			
		else:
			velocity.x = 0;
	velocity.y += gravityForce * delta
	if is_on_floor():
		velocity.y = 0;
	move_and_slide(velocity*delta,Vector2.UP);
	pass;
