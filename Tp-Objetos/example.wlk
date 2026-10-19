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

    method cantidadDePiezasDelTraje() {
    return traje.cantidadDePiezas()
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

    method cantidadDePiezas() {
    return 1
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
    
    method danioSufrido(danioBase) {
        return danioBase // No reduce el daño recibido
    }

    method experienciaGanada() {
        if (self.estaGastado()) {
        return 1 // Si está gastado, no otorga el beneficio del multiplicador
        }
        return configuracionEntrenamiento.multiplicadorExp()
    }
}
object configuracionEntrenamiento {
    var property multiplicadorExp = 2
}

class Pieza {
    const property resistencia
    var property desgaste = 0

    method usar() {
        desgaste += 5
    }

    method estaGastada() {
        return desgaste >= 20
    }
}
class TrajeModularizado {
    const property piezas = []

    method piezasUtiles() {
        return piezas.filter({ pieza => !pieza.estaGastada() })
    }

    method danioSufrido(danioBase) {
        return danioBase -
            self.piezasUtiles().sum({ pieza => pieza.resistencia() })
    }

    method experienciaGanada() {
        if (piezas.isEmpty()) {
            return 0
        }
        return self.piezasUtiles().size() / piezas.size()
    }

    method usar() {
        piezas.forEach({ pieza => pieza.usar() })
    }

    method estaGastado() {
        return piezas.all({ pieza => pieza.estaGastada() })
    }

    method cantidadDePiezas() {
        return piezas.size()
    }
}
object powerIsBest {
    method seleccionar(guerreros) {
        return guerreros.sortedBy({ primero, segundo =>
            primero.potencialOfensivo() > segundo.potencialOfensivo()
        }).take(16)
    }
}

object funny {
    method seleccionar(guerreros) {
        return guerreros.sortedBy({ primero, segundo =>
            primero.cantidadDePiezasDelTraje() >
                segundo.cantidadDePiezasDelTraje()
        }).take(16)
    }
}

object surprise {
    method seleccionar(guerreros) {
        const disponibles = []
        disponibles.addAll(guerreros)

        const seleccionados = []

        16.times({ indice =>
            const elegido = disponibles.anyOne()
            seleccionados.add(elegido)
            disponibles.remove(elegido)
        })

        return seleccionados
    }
}

class Torneo {
    const property inscriptos = []
    var property modalidad = powerIsBest

    method participantes() {
        const candidatos = inscriptos.withoutDuplicates()

        if (candidatos.size() < 16) {
            throw new Exception(
                message = "Se necesitan al menos 16 guerreros distintos"
            )
        }

        return modalidad.seleccionar(candidatos)
    }
}
