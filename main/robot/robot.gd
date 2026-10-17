extends Node2D
class_name Robot

@onready var wireframe: TextureRect = %Wireframe
@onready var head: TextureRect = %Head
@onready var head_top: TextureRect = %HeadTop
@onready var nose: TextureRect = %Nose
@onready var eyes: TextureRect = %Eyes
@onready var mouth: TextureRect = %Mouth
@onready var ears: TextureRect = %Ears
@onready var body_top: TextureRect = %BodyTop
@onready var body_bottom: TextureRect = %BodyBottom
@onready var left_arm: TextureRect = %LeftArm
@onready var left_shoulder: TextureRect = %LeftShoulder
@onready var right_arm: TextureRect = %RightArm
@onready var right_shoulder: TextureRect = %RightShoulder

@onready var brain: TextureRect = %Brain
@onready var heart: TextureRect = %Heart
@onready var guts: TextureRect = %Guts

enum BodyPart {
	HEAD,
	HEAD_TOP,
	NOSE,
	EYES,
	MOUTH,
	EARS,
	BODY_TOP,
	BODY_BOTTOM,
	ARM,
	SHOULDER,
	BRAIN,
	HEART,
	GUTS
}
