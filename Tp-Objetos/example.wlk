    class Guerrero {
    var property potencialOfensivo
    var property experiencia = 0
    const property energiaOriginal
    var property energia = energiaOriginal
    var property traje = new TrajeComun(porcentajeProteccion = 0)

    // El atacante delega la recepción del daño en el oponente
    method atacar(unGuerrero) {
        unGuerrero.recibirAtaque(potencialOfensivo)
    }

    // El guerrero atacado calcula el daño real usando su traje y actualiza su energía/experiencia
    method recibirAtaque(potencialAtacante) {
        const danioBase = potencialAtacante * 0.1
        const danioReal = traje.danioSufrido(danioBase)
        
        energia = (energia - danioReal).max(0)
        experiencia += traje.experienciaGanada()
    }

    // Restaura la energía al valor con el que comenzó
    method comerSemillaDelErmitano() {
        energia = energiaOriginal
    }
}

    // --- Trajes (Punto 2) ---

class TrajeComun {
    var property porcentajeProteccion = 0

    method danioSufrido(danioBase) {
        return danioBase * (1 - porcentajeProteccion / 100)
    }

    method experienciaGanada() {
        return 1
    }
}

class TrajeDeEntrenamiento {
    var property multiplicadorExp = 2

    method danioSufrido(danioBase) {
        return danioBase // No disminuye el daño recibido
    }

    method experienciaGanada() {
        return 1 * multiplicadorExp // Multiplica la experiencia normal
    }
}