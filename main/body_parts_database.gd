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

func get_body_part_texture(body_part: BodyPartType.Type, id: int) -> CompressedTexture2D:
	var textures: Array[CompressedTexture2D]

	match body_part:
		BodyPartType.Type.HEAD:
			textures = head_textures
		BodyPartType.Type.HEAD_TOP:
			textures = head_top_textures
		BodyPartType.Type.NOSE:
			textures = nose_textures
		BodyPartType.Type.EYES:
			textures = eyes_textures
		BodyPartType.Type.MOUTH:
			textures = mouth_textures
		BodyPartType.Type.EARS:
			textures = ears_textures
		BodyPartType.Type.BODY_TOP:
			textures = body_top_textures
		BodyPartType.Type.BODY_BOTTOM:
			textures = body_bottom_textures
		BodyPartType.Type.ARM:
			textures = arm_textures
		BodyPartType.Type.SHOULDER:
			textures = shoulder_textures
		_:
			return null

	if id < 0 or id >= textures.size():
		return null

	return textures[id]

func get_body_part_array_size(body_part: BodyPartType.Type) -> int:
	match body_part:
		BodyPartType.Type.HEAD:
			return head_textures.size()
		BodyPartType.Type.HEAD_TOP:
			return head_top_textures.size()
		BodyPartType.Type.NOSE:
			return nose_textures.size()
		BodyPartType.Type.EYES:
			return eyes_textures.size()
		BodyPartType.Type.MOUTH:
			return mouth_textures.size()
		BodyPartType.Type.EARS:
			return ears_textures.size()
		BodyPartType.Type.BODY_TOP:
			return body_top_textures.size()
		BodyPartType.Type.BODY_BOTTOM:
			return body_bottom_textures.size()
		BodyPartType.Type.ARM:
			return arm_textures.size()
		BodyPartType.Type.SHOULDER:
			return shoulder_textures.size()
		_:
			return 0
