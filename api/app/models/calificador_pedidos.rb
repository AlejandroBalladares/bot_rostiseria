class CalificadorPedidos
  def initialize(calificacion_repository)
    @calificacion_repository = calificacion_repository
  end

  def calificar(id_pedido, puntuacion)
    calificacion = Calificacion.new(id_pedido, puntuacion)
    @calificacion_repository.save(calificacion)
    calificacion
  end
end
