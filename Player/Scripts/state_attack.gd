class_name State_Attack extends State

var attacking : bool = false
@onready var idle: State = $"../Idle"
@onready var walk  : State = $"../Walk"
@onready var player_animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = %AttackHurtBox





@export var attack_sound : AudioStream
@export_range(1,20,0.6) var decelerate_speed : float = 5.0 


## what happens when the player enters this state?
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play( "attack_" + player.AnimDirection() )
	player_animation_player.animation_finished.connect( EndAttack ) 
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attacking = true
	
	hurt_box.monitoring = true
	pass




## what happens when the player exits this state?
func Exit() -> void:
	player_animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	
	await get_tree().create_timer( 0.15 ).timeout
	hurt_box.monitoring = false
	pass




## what happens during the _process update in this state?
func Process( _delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null



## what happens during the _physics_process update in this state?
func Physics(_delta : float ) -> State:
	return null


## what happens with input events in this state?
func HandleInput(_event: InputEvent ) -> State:
	return null
	
func EndAttack(_newAnimName : String) -> void:
		attacking = false
	
