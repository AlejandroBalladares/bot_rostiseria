class Calificacion
  attr_accessor :id
  attr_reader :id_pedido, :puntuacion

  def initialize(id_pedido, puntuacion, id=nil)
    @id_pedido = id_pedido
    @puntuacion = puntuacion
    @id = id
    validar!
  end

  def validar!
    raise CalificacionPuntajeInvalidoError if puntuacion < 1 || puntuacion > 5
  end
end
