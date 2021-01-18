extends Control


export (int) var playerId = 0;

var player:CharacterBase;

onready var progressBar:TextureProgress = get_node("HealthBar");

onready var abilityBar:ProgressBar = get_node("AbilityBar");

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player"+String(playerId));
	pass # Replace with function body.


func _process(delta):
	if player != null:
		progressBar.value = player.health;
		abilityBar.value = player.specialAttackChargeAmount;
	pass
