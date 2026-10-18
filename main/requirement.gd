extends Node
class_name Requirement

enum Type {
	REPAIR,
	POLISHING,
	PAINTING,
	REPLACEMENT
}

var type: Type
var body_part: BodyPart
var completed: bool

func init(_type: Type, _body_part: BodyPart):
	type = _type
	body_part = _body_part

func complete():
	completed = true
