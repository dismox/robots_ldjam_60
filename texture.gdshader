shader_type canvas_item;

uniform sampler2D polish_texture : source_color;
uniform float polish_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    vec4 polish = texture(polish_texture, UV);

    float alpha = base.a * polish.a * polish_strength;

    COLOR.rgb = mix(base.rgb, polish.rgb, alpha);
    COLOR.a = base.a;
}