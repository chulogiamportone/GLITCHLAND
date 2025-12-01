shader_type canvas_item;

// Tipo de daltonismo: 0 = Normal, 1 = Protanopia, 2 = Deuteranopia, 3 = Tritanopia
uniform int daltonism_type : hint_range(0, 3) = 1;
uniform float strength : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
mat3 get_correction_matrix(int type) {
    mat3 protanopia = mat3(
        vec3(0.567, 0.433, 0.0),
        vec3(0.558, 0.442, 0.0),
        vec3(0.0, 0.242, 0.758)
    );

    mat3 deuteranopia = mat3(
        vec3(0.625, 0.375, 0.0),
        vec3(0.7, 0.3, 0.0),
        vec3(0.0, 0.3, 0.7)
    );

    mat3 tritanopia = mat3(
        vec3(0.95, 0.05, 0.0),
        vec3(0.0, 0.433, 0.567),
        vec3(0.0, 0.475, 0.525)
    );

    mat3 normal = mat3(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, 1.0, 0.0),
        vec3(0.0, 0.0, 1.0)
    );

    if (type == 1) return protanopia;
    else if (type == 2) return deuteranopia;
    else if (type == 3) return tritanopia;
    else return normal;
}

void fragment() {
    // Lee el color de la pantalla renderizada
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

    if (daltonism_type > 0) {
        mat3 correction = get_correction_matrix(daltonism_type);
        vec3 corrected = correction * color.rgb;
        color.rgb = mix(color.rgb, corrected, strength);
    }

    COLOR = color;
}