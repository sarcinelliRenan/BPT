
// Periodic Table Tile for Br
$fn = 50;  // Resolution for curved surfaces

SIMBOLO = "Br";
N_ATOMICO = "35";
RAIO_DOS_PONTOS_MM = 2;
ALTURA_DOS_PONTOS_MM = 2;
ESPACO_ENTRE_PONTOS_MM = RAIO_DOS_PONTOS_MM / 0.3;
POSE_INICIAL_X_MM = 10;
POSE_INICIAL_Y_MM = 40;
TAMANHO_DO_CUBO_MM = [100, 100, 20];
ESPACO_ENTRE_PLACAS_MM = 10;

// Module for rounded cube
module rounded_cube(size, r) {
    hull() {
        translate([r, r, 0])
        cylinder(h = size[2], r = r);
        
        translate([size[0]-r, r, 0])
        cylinder(h = size[2], r = r);
        
        translate([size[0]-r, size[1]-r, 0])
        cylinder(h = size[2], r = r);
        
        translate([r, size[1]-r, 0])
        cylinder(h = size[2], r = r);
    }
}

// Blocos em Braille – Grupo 1 (somente número e símbolo)
module braille_dot(x, y) {
    translate([x, y, 0])
        cylinder(h = ALTURA_DOS_PONTOS_MM, r = RAIO_DOS_PONTOS_MM);
}

// Map Braille padrão
function braille_map(c) = 
    c == "a" || c == "A" ? [1] :
    c == "b" || c == "B" ? [1,2] :
    c == "c" || c == "C" ? [1,4] :
    c == "d" || c == "D" ? [1,4,5] :
    c == "e" || c == "E" ? [1,5] :
    c == "f" || c == "F" ? [1,2,4] :
    c == "g" || c == "G" ? [1,2,4,5] :
    c == "h" || c == "H" ? [1,2,5] :
    c == "i" || c == "I" ? [2,4] :
    c == "j" || c == "J" ? [2,4,5] :
    c == "k" || c == "K" ? [1,3] :
    c == "l" || c == "L" ? [1,2,3] :
    c == "m" || c == "M" ? [1,3,4] :
    c == "n" || c == "N" ? [1,3,4,5] :
    c == "o" || c == "O" ? [1,3,5] :
    c == "p" || c == "P" ? [1,2,3,4] :
    c == "q" || c == "Q" ? [1,2,3,4,5] :
    c == "r" || c == "R" ? [1,2,3,5] :
    c == "s" || c == "S" ? [2,3,4] :
    c == "t" || c == "T" ? [2,3,4,5] :
    c == "u" || c == "U" ? [1,3,6] :
    c == "v" || c == "V" ? [1,2,3,6] :
    c == "w" || c == "W" ? [2,4,5,6] :
    c == "x" || c == "X" ? [1,3,4,6] :
    c == "y" || c == "Y" ? [1,3,4,5,6] :
    c == "z" || c == "Z" ? [1,3,5,6] :
    c == "1" ? [1] :
    c == "2" ? [1,2] :
    c == "3" ? [1,4] :
    c == "4" ? [1,4,5] :
    c == "5" ? [1,5] :
    c == "6" ? [1,2,4] :
    c == "7" ? [1,2,4,5] :
    c == "8" ? [1,2,5] :
    c == "9" ? [2,4] :
    c == "0" ? [2,4,5] :
    [];

module braille_char(char, base_x, base_y) {
    for (p = braille_map(char)) {
        row = (p - 1) % 3;
        col = floor((p - 1) / 3);
        braille_dot(base_x + col * ESPACO_ENTRE_PONTOS_MM, base_y - row * ESPACO_ENTRE_PONTOS_MM);
    }
}

module braille_text(text, start_x, start_y) {
    for (i = [0:len(text)-1])
        braille_char(text[i], start_x + i * RAIO_DOS_PONTOS_MM*8, start_y);
}

module bloco(numero, simbolo) {
    union() {
        cube(TAMANHO_DO_CUBO_MM);
        braille_text(numero, POSE_INICIAL_X_MM, POSE_INICIAL_Y_MM);   // Número atômico
        braille_text(simbolo, POSE_INICIAL_X_MM, POSE_INICIAL_Y_MM - RAIO_DOS_PONTOS_MM*8);  // Símbolo químico
    }
}


union() {
    difference() {
        // Base cube with rounded corners
        rounded_cube([50, 50, 10], 2);
        
        // Element symbol (top side)
        translate([25.0, 20.0, 8])
            linear_extrude(height = 2)
            text(SIMBOLO, 
                 size = 16.666666666666668,
                 halign = "center",
                 valign = "center");
        
        // Atomic number (top side)
        translate([5, 42, 8])
            linear_extrude(height = 2)
            text(N_ATOMICO, 
                 size = 10.0,
                 halign = "left",
                 valign = "top");
    }
    
    translate([50, 0, 0])
    {
        scale([-1, 1, -1])
        {
            braille_text(N_ATOMICO, POSE_INICIAL_X_MM, POSE_INICIAL_Y_MM);
            braille_text(SIMBOLO, POSE_INICIAL_X_MM, POSE_INICIAL_Y_MM - RAIO_DOS_PONTOS_MM*8);
        }
    }
    
}