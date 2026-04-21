require 'integration_helper'

describe Persistence::Repositories::CalificacionRepository do
  let(:calificacion_repo) { Persistence::Repositories::CalificacionRepository.new }
  let(:pedido_repo) { Persistence::Repositories::PedidoRepository.new }
  let(:menu_repo) { Persistence::Repositories::MenuRepository.new }

  it 'guarda una calificacion' do
    menu = menu_repo.find(1)
    pedido = Pedido.new(menu, nil, EstadoPedido::ENTREGADO)
    pedido_repo.save(pedido)
    calificacion = Calificacion.new(pedido.id, 5)
    calificacion_repo.save(calificacion)

    expect(calificacion_repo.all.count).to eq(1)
  end

  it 'obtener calificacion de un pedido' do
    menu = menu_repo.find(1)
    pedido = Pedido.new(menu, nil, EstadoPedido::ENTREGADO)
    pedido_repo.save(pedido)
    calificacion = Calificacion.new(pedido.id, 5)
    calificacion_repo.save(calificacion)

    expect(calificacion_repo.find_by_id_pedido(pedido.id).puntuacion).to eq 5
  end
end
