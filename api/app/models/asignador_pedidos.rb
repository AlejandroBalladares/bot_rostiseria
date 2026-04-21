class AsignadorPedidos
  def initialize(repartidor_repo)
    @repartidor_repo = repartidor_repo
  end

  def asignar(pedido)
    repartidores = @repartidor_repo.all
    raise RepartidorNoDisponibleError if repartidores.empty?

    repartidor = asignar_repartidor(repartidores, pedido)
    begin
      pedido.asignar_repartidor(repartidor)
    rescue
      raise RepartidorNoDisponibleError
    end
  end

  def asignar_repartidor(repartidores, pedido)
    repartidores.filter { |repartidor| repartidor.tiene_espacio_en_la_mochila?(pedido) }
                .sort_by { |repartidor| [-repartidor.carga_actual, @repartidor_repo.cantidad_pedidos_entregados(repartidor.id)] } # default sort es menor a mayor
                .first
  end
end
