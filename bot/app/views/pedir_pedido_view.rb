class PedirPedidoView
  attr_reader :estado_pedido

  def initialize(pedido)
    @pedido = pedido
  end

  def mensaje
    "Gracias por tu pedido. Consulta el estado de tu pedido con /pedido #{@pedido.id}"
  end
end
