shader_type spatial;

uniform sampler2D texture; // Texture for height map
uniform float height_scale = 1.0; // Scale for height

void vertex() {
    vec2 uv = UV; // Get UV coordinates
    vec4 texColor = texture(texture, uv); // Sample the texture
    float height = texColor.r; // Use the red channel for height

    // Displace the vertex position based on the height value.
    VERTEX.y += height * height_scale; // Adjust Y position for displacement
}

void fragment() {
    vec2 uv = UV; // Get UV coordinates
    vec4 texColor = texture(texture, uv); // Sample the texture
    ALBEDO = texColor.rgb; // Set the color of the surface
}
