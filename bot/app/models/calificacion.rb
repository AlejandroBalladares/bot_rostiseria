class Calificacion
  attr_reader :id_pedido

  def initialize(id_pedido, puntuacion)
    @id_pedido = id_pedido
    @puntuacion = puntuacion
  end

  def to_body
    "{\"puntuacion\": #{@puntuacion}}"
  end
end
