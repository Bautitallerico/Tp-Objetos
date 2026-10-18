class Guerrero {
    var property potencialOfensivo
    var property experiencia = 0
    const property energiaOriginal
    var property energia = energiaOriginal
    var property traje = new TrajeComun(porcentajeProteccion = 0)

    // El atacante le delega al rival la recepción del ataque
    method atacar(unGuerrero) {
        unGuerrero.recibirAtaque(potencialOfensivo)
    }

    // El guerrero atacado calcula el daño recibido, actualiza su estado y desgasta su traje
    method recibirAtaque(potencialAtacante) {
        const danioBase = potencialAtacante * 0.1
        const danioReal = traje.danioSufrido(danioBase)
        
        energia = (energia - danioReal).max(0)
        experiencia += traje.experienciaGanada()
        traje.usar()
    }

    // Restaura la energía al valor con el que comenzó
    method comerSemillaDelErmitano() {
        energia = energiaOriginal
    }
}

// --- Trajes y Desgaste (Puntos 2 y 3) ---

// Clase base para evitar repetir la lógica del desgaste en cada tipo de traje
class Traje {
    var property desgaste = 0

    // Aumenta el desgaste en 5 unidades cada vez que se usa el traje al ser atacado
    method usar() {
        desgaste += 5
    }

    // Indica si el traje alcanzó o superó las 100 unidades de desgaste
    method estaGastado() {
        return desgaste >= 100
    }
}

class TrajeComun inherits Traje {
    var property porcentajeProteccion = 0

    method danioSufrido(danioBase) {
        if (self.estaGastado()) {
        return danioBase // Si está gastado, no protege
        }
        return danioBase * (1 - porcentajeProteccion / 100)
    }

    method experienciaGanada() {
        return 1
    }
}

class TrajeDeEntrenamiento inherits Traje {
    var property multiplicadorExp = 2

    method danioSufrido(danioBase) {
        return danioBase // No reduce el daño recibido
    }

    method experienciaGanada() {
        if (self.estaGastado()) {
        return 1 // Si está gastado, no otorga el beneficio del multiplicador
        }
        return 1 * multiplicadorExp
    }
}