extends Resource
class_name BodyPartsDatabase

@export var head_textures: Array[CompressedTexture2D]
@export var head_top_textures: Array[CompressedTexture2D]
@export var nose_textures: Array[CompressedTexture2D]
@export var eyes_textures: Array[CompressedTexture2D]
@export var mouth_textures: Array[CompressedTexture2D]
@export var ears_textures: Array[CompressedTexture2D]
@export var body_top_textures: Array[CompressedTexture2D]
@export var body_bottom_textures: Array[CompressedTexture2D]
@export var arm_textures: Array[CompressedTexture2D]
@export var shoulder_textures: Array[CompressedTexture2D]

func get_body_part_texture(body_part: BodyPart.Type, id: int) -> CompressedTexture2D:
	var textures: Array[CompressedTexture2D]

	match body_part:
		BodyPart.Type.HEAD:
			textures = head_textures
		BodyPart.Type.HEAD_TOP:
			textures = head_top_textures
		BodyPart.Type.NOSE:
			textures = nose_textures
		BodyPart.Type.EYES:
			textures = eyes_textures
		BodyPart.Type.MOUTH:
			textures = mouth_textures
		BodyPart.Type.EARS:
			textures = ears_textures
		BodyPart.Type.BODY_TOP:
			textures = body_top_textures
		BodyPart.Type.BODY_BOTTOM:
			textures = body_bottom_textures
		BodyPart.Type.ARM:
			textures = arm_textures
		BodyPart.Type.SHOULDER:
			textures = shoulder_textures
		_:
			return null

	return textures[id]
	#return textures.get(id) as CompressedTexture2D
