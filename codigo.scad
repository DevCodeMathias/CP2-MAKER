$fn = 120;

// ==========================
// MEDIDAS FINAIS
// ==========================
num_pas = 5;

// base
espessura_base = 6;

// domo
altura_domo = 2.8;
diametro_domo = 13;

// centro
diametro_miolo = 13;
raio_miolo = diametro_miolo / 2;

// pá (AJUSTADO COM SUA MEDIDA)
largura_pa = 9.0;
comprimento_pa = 25.0;   // mais comprida como você pediu
ponta_pa = 4.2;

// furo inferior (não atravessa o topo)
diametro_furo = 5.0;
profundidade_furo = 4.5;

// ==========================
// MÓDULOS
// ==========================

module pa_2d() {
    polygon(points = [
        [-largura_pa/2 + 0.6, 0],
        [ largura_pa/2 - 0.6, 0],
        [ largura_pa/2, comprimento_pa - ponta_pa],
        [ 0, comprimento_pa],
        [-largura_pa/2, comprimento_pa - ponta_pa]
    ]);
}

module perfil_2d() {
    union() {
        circle(r = raio_miolo);

        for (i = [0 : 360/num_pas : 360 - 360/num_pas]) {
            rotate(i)
                pa_2d();
        }
    }
}

module corpo() {
    linear_extrude(height = espessura_base)
        perfil_2d();
}

module domo() {
    translate([0, 0, espessura_base])
        scale([1, 1, altura_domo / (diametro_domo / 2)])
            sphere(r = diametro_domo / 2);
}

module furo_inferior() {
    // furo só por baixo
    translate([0, 0, -0.01])
        cylinder(h = profundidade_furo, d = diametro_furo);
}

// ==========================
// MODELO FINAL
// ==========================
difference() {
    union() {
        corpo();
        domo();
    }

    furo_inferior();
}