extends CharacterBase

enum AIState{ATTACK,IDLE,BLOCKING}

var currentState = AIState.IDLE;

export (float) var aiAttackInterval = 1;
#ai can not attack sooner then this timer runs out
var attackResetTimer:Timer;

func _ready():
	._ready()
	attackResetTimer = get_node("AttackResetTimer");
	pass;


func _update_ai_state():
	if enemy != null:
		if enemy.attacking:
			currentState = AIState.BLOCKING;
		elif attackResetTimer.time_left == 0:
			currentState = AIState.ATTACK;
		else:
			currentState = AIState.IDLE;
		print(attackResetTimer.time_left);
	pass

func _update_ai(_delta):
	if !attacking:
		if currentState == AIState.ATTACK:
			._init_attack_timers();
		elif currentState == AIState.BLOCKING:
			blocking = true;
		else:
			blocking = false;
	pass;

func _physics_process(delta):
	if !dead:
		._physics_process(delta);
		_update_ai_state();
		_update_ai(delta);
	pass

func _is_of_enemy_type(var body)->bool:
	return body is CharacterBase;

func _ai_react_to_attacking():
	attackResetTimer.wait_time = aiAttackInterval;
	attackResetTimer.start();
	pass;
