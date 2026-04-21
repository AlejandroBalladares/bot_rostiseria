class Pedido
  attr_reader :menu, :estado, :id_repartidor, :calificacion, :esta_lloviendo, :cliente
  attr_accessor :id

  def initialize(menu, id_repartidor = nil, estado = EstadoPedido::RECIBIDO, id = nil, calificacion = nil, esta_lloviendo = false, cliente = nil)
    @id = id
    @menu = menu
    @id_repartidor = id_repartidor
    @estado = estado
    @calificacion = calificacion
    @esta_lloviendo = esta_lloviendo
    @cliente = cliente
  end

  def siguiente_estado(asignador_pedidos)
    case @estado
    when EstadoPedido::RECIBIDO
      @estado = EstadoPedido::EN_PREPARACION
    when EstadoPedido::EN_PREPARACION
      begin
        asignador_pedidos.asignar(self)
        @estado = EstadoPedido::EN_CAMINO
      rescue RepartidorNoDisponibleError
        @estado = EstadoPedido::EN_ESPERA
      end
    else
      @estado = EstadoPedido::ENTREGADO
    end
  end

  def asignar_repartidor(repartidor)
    repartidor.asignar_pedido(self)
    @id_repartidor = repartidor.id
  end

  def obtener_peso
    @menu.peso
  end

  def es_cancelable?
    (@estado == EstadoPedido::RECIBIDO or @estado == EstadoPedido::EN_PREPARACION)
  end

  def es_calificable?
    (@estado == EstadoPedido::ENTREGADO)
  end

  def pertenece_a?(id_telegram)
    @cliente.id_telegram == id_telegram
  end
end

module EstadoPedido
  RECIBIDO = 'RECIBIDO'.freeze
  EN_PREPARACION = 'EN_PREPARACION'.freeze
  EN_ESPERA = 'EN_ESPERA'.freeze
  EN_CAMINO = 'EN_CAMINO'.freeze
  ENTREGADO = 'ENTREGADO'.freeze
end
