class Guerrero {
const potencialOfensivo = 0
var experiencia 
const energiaOriginal = 0
var energia = energiaOriginal
const traje = new TrajeComun()


method atacar(_guerrero) {
    var ataque = (potencialOfensivo * 0.1)

    if (_guerrero.traje() == new TrajeComun()) {
        ataque = ataque - _guerrero.traje().resistirAtaque(ataque)
    }
    _guerrero.energia(_guerrero.energia() - ataque)
    //_guerrero.traje().desgaste() += 5
    
    if (traje == new TrajeDeEntrenamiento()) {
        experiencia += traje.multiplicarExp()
    }
    else{
        experiencia += 1
    }
    
}

method comerSemillaDelErmitaño() {
    energia = energiaOriginal
}
}

//algo sobre hacerlo asi en dos clases me hace ruido porque terminaría repitiendo mucha lógica
//a partir del punto 2
class TrajeComun {
    const defensa = 0
    var desgaste = 0

    method resistirAtaque(ataque) {
    const ataqueReducido = ataque * (defensa/100)
    return ataqueReducido
    }

}

class TrajeDeEntrenamiento {
    const multiplicadorDeXp = 2
    var desgaste = 0

    method multiplicarExp(){
    const experienciaGanada = 1 * multiplicadorDeXp
    return experienciaGanada
    }

}
