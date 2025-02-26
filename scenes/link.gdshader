shader_type canvas_item;

uniform vec4 OLD_COLOUR_1 : source_color;
uniform vec4 OLD_COLOUR_2 : source_color;
uniform vec4 OLD_COLOUR_3 : source_color;
uniform vec4 OLD_COLOUR_4 : source_color;

uniform vec4 NEW_COLOUR_1 : source_color;
uniform vec4 NEW_COLOUR_2 : source_color;
uniform vec4 NEW_COLOUR_3 : source_color;
uniform vec4 NEW_COLOUR_4 : source_color;

const float THRESHOLD = 0.01;

void fragment() {
    vec4 current_colour = texture(TEXTURE, UV);
    
    if (distance(current_colour, OLD_COLOUR_1) < THRESHOLD) {
        COLOR = NEW_COLOUR_1;
    } 
    else if (distance(current_colour, OLD_COLOUR_2) < THRESHOLD) {
        COLOR = NEW_COLOUR_2;
    } 
    else if (distance(current_colour, OLD_COLOUR_3) < THRESHOLD) {
        COLOR = NEW_COLOUR_3;
    } 
    else if (distance(current_colour, OLD_COLOUR_4) < THRESHOLD) {
        COLOR = NEW_COLOUR_4;
    } 
    else {
        COLOR = current_colour;
    }
}