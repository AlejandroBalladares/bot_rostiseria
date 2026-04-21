class Mochila
  attr_reader :pedidos, :peso

  PESO_MOCHILA_VACIA = 0
  PESO_MAXIMO = 3

  def initialize(pedidos = [])
    @pedidos = pedidos
    @peso = if pedidos.length.positive?
              pedidos.map { |pedido| pedido.obtener_peso}.reduce(:+)
            else
              PESO_MOCHILA_VACIA
            end
  end

  def agregar_pedido(pedido)
    raise MochilaLlenaError if (@peso + pedido.obtener_peso) > PESO_MAXIMO

    @pedidos.append(pedido)
    @peso += pedido.obtener_peso
  end

  def hay_espacio?(pedido)
    (@peso + pedido.obtener_peso) <= PESO_MAXIMO
  end
end
