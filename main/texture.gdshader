shader_type canvas_item;

uniform sampler2D rust_texture : source_color;
uniform float rust_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec4 rust = texture(rust_texture, UV);

	float blend = rust.a * rust_strength;

	COLOR = vec4(
		base.rgb * mix(vec3(1.0), rust.rgb, blend),
		base.a
	) * COLOR;
}