class EstadoPedidoView
  def initialize(estado_pedido)
    @estado_pedido = estado_pedido
  end

  def mensaje
    enviar_estado
  end

  def enviar_estado
    case @estado_pedido.estado
    when 'RECIBIDO'
      'Su pedido fue recibido, en unos instantes comenzará su preparación'
    when 'EN_PREPARACION'
      'Su pedido esta en preparación'
    when 'EN_ESPERA'
      'Su pedido esta en espera, se le asignará un repartidor cuando esté disponible'
    when 'EN_CAMINO'
      'Su pedido esta en camino, llegará a su domicilio en los proximos minutos'
    when 'ENTREGADO'
      'Su pedido ya fue entregado, esperamos que lo haya disfrutado'
    end
  end
end
