require 'integration_helper'

describe AsignadorPedidos do
  let(:repartidor_repo) { Persistence::Repositories::RepartidorRepository.new }
  let(:pedido_repo) { Persistence::Repositories::PedidoRepository.new }
  let(:menu) { Menu.new(1, 'Menu individual', 100) }
  let(:pedido) { Pedido.new(Menu.new(1, 'Menu individual', 100), nil, EstadoPedido::EN_PREPARACION) }

  it 'asignar cuando existen repartidores asigna un repartidor al pedido' do
    repartidor_repo.save(Repartidor.new('Pepe', 321321))
    asignador_pedidos = AsignadorPedidos.new(repartidor_repo)
    asignador_pedidos.asignar(pedido)
    expect(pedido.id_repartidor).to_not be_nil
  end

  it 'asignar un pedido pareja cuando existe un repartidor con 2 pedidos individuales y otro repartidor sin pedidos, asigna al repartidor sin pedidos' do
    repartidor_1 = repartidor_repo.save(Repartidor.new('Pepe', 321321))
    repartidor_2 = repartidor_repo.save(Repartidor.new('Pepi', 123123))

    pedido_repo.save(Pedido.new(menu, repartidor_1.id, EstadoPedido::EN_CAMINO))
    pedido_repo.save(Pedido.new(menu, repartidor_1.id, EstadoPedido::EN_CAMINO))

    asignador_pedidos = AsignadorPedidos.new(repartidor_repo)

    pedido_pareja = Pedido.new(Menu.new(2, 'Menu pareja', 175, 2), nil, EstadoPedido::EN_PREPARACION)
    pedido_pareja.siguiente_estado(asignador_pedidos)

    expect(pedido_pareja.id_repartidor).to eq(repartidor_2.id)
  end

  # Revisar test, posiblemente esté mal
  xit 'asignar 4 pedidos individuales a un mismo repartidor deja el pedido en espera' do
    repartidor_repo.save(Repartidor.new('Pepe', 321321))
    asignador_pedidos = AsignadorPedidos.new(repartidor_repo)
    (1..3).each do |_|
      asignador_pedidos.asignar(Pedido.new(menu, nil, EstadoPedido::EN_PREPARACION))
    end

    asignador_pedidos.asignar(pedido)
    expect(pedido.estado).to eq(EstadoPedido::EN_ESPERA)
  end
end
