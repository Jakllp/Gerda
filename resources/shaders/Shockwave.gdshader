shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;
uniform float blurr;
uniform float red_shift;
uniform float green_shift;
uniform float blue_shift;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = ( SCREEN_UV - vec2(0.5, 0)) / vec2(ratio, 1.0) + vec2(0.5, 0);
	float mask = (1.0 - smoothstep(size - blurr, size, length(scaledUV - center)))
	* smoothstep(size-thickness-blurr, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV-center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	COLOR = vec4( texture(SCREEN_TEXTURE, SCREEN_UV - disp).r + red_shift * mask, 
		texture(SCREEN_TEXTURE, SCREEN_UV - disp).g + green_shift * mask,
		texture(SCREEN_TEXTURE, SCREEN_UV - disp).b + blue_shift * mask,
		1.0);
	//COLOR.rgb = vec3(mask);
}
