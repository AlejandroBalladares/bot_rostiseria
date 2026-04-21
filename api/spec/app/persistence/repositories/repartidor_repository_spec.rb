require 'integration_helper'

describe Persistence::Repositories::RepartidorRepository do
  before(:each) do
    @repartidor_repo = Persistence::Repositories::RepartidorRepository.new
    @repartidor_repo.delete_all
    @pedido_repo = Persistence::Repositories::PedidoRepository.new
    @pedido_repo.delete_all

    @repartidor = Repartidor.new('José Maria', 1234567)
  end

  it 'guarda un repartidor' do
    @repartidor_repo.save(@repartidor)
    expect(@repartidor_repo.all.count).to eq(1)
  end

  it 'guardar devuelve el id' do
    repartidor_insertado = @repartidor_repo.save(@repartidor)
    expect(repartidor_insertado.id).to_not be_nil
  end

  it 'obtener cantidad de pedidos asignados al repartidor' do
    repartidor_insertado = @repartidor_repo.save(@repartidor)

    pedidos_guardados = []
    (1..2).each do |_|
      pedido = @pedido_repo.save(Pedido.new(Menu.new(1, 'Menu individual', 100, 1), repartidor_insertado.id, EstadoPedido::EN_CAMINO))
      pedidos_guardados.append(pedido)
    end

    peso_expected = pedidos_guardados.map { |pedido| pedido.obtener_peso }.reduce(:+)
    pedidos_expected = pedidos_guardados.map {|pedido| have_attributes(
      id: pedido.id,
      menu: have_attributes(
        id: pedido.menu.id,
        precio: pedido.menu.precio
      ),
      id_repartidor: pedido.id_repartidor,
      estado: pedido.estado,
      calificacion: pedido.calificacion

    )}

    repartidor = @repartidor_repo.find(repartidor_insertado.id)
    expect(repartidor.mochila.peso).to eq(peso_expected)
    expect(repartidor.mochila.pedidos).to match_array(pedidos_expected)
  end

  it 'obtener cantidad de pedidos entregados por el repartidor' do
    repartidor_insertado = @repartidor_repo.save(@repartidor)

    pedidos_guardados = []
    (1..2).each do |_|
      pedido = @pedido_repo.save(Pedido.new(Menu.new(1, 'Menu individual', 100, 1), repartidor_insertado.id, EstadoPedido::ENTREGADO))
      pedidos_guardados.append(pedido)
    end

    cantidad_pedidos_entregados = @repartidor_repo.cantidad_pedidos_entregados(repartidor_insertado.id)
    expect(cantidad_pedidos_entregados).to eq(pedidos_guardados.length)
  end
end
