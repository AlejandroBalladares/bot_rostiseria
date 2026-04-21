require 'integration_helper'

describe Persistence::Repositories::PedidoRepository do
  let(:pedido_repo) { Persistence::Repositories::PedidoRepository.new }
  let(:repartidor_repo) { Persistence::Repositories::RepartidorRepository.new }
  let(:menu_repo) { Persistence::Repositories::MenuRepository.new }
  let(:cliente_repo) { Persistence::Repositories::ClienteRepository.new }
  let(:calificacion_repo) { Persistence::Repositories::CalificacionRepository.new }
  let(:menu) { Menu.new(1, "Menu", 100) }
  let(:pedido) { Pedido.new(menu) }
  let(:repartidor) { repartidor_repo.save(Repartidor.new('Pepe', 321321)) }

  before(:all) do
    Persistence::Repositories::MenuRepository.new.save(Menu.new(1, "Menu", 100))
  end

  it 'guarda un pedido' do
    pedido_repo.save(pedido)
    expect(pedido_repo.all.count).to eq(1)
  end

  it 'asociar un pedido a un cliente' do
    id_telegram_esperado = 789789
    cliente = Cliente.new('Juan', 'Calle Falsa 123', 432423, id_telegram_esperado)
    cliente_repo.save(cliente)

    pedido = Pedido.new(menu, nil, EstadoPedido::RECIBIDO, nil, nil, nil, cliente)
    pedido = pedido_repo.save(pedido)

    expect(pedido_repo.find(pedido.id).cliente.id_telegram).to eq(id_telegram_esperado)
  end

  it 'estado inicial es RECIBIDO' do
    pedido_creado = pedido_repo.save(pedido)
    expect(pedido_repo.find(pedido_creado.id).estado).to eq('RECIBIDO')
  end

  it 'asignar repartidor a pedido guarda id_repartidor' do
    pedido.asignar_repartidor(repartidor)
    pedido_creado = pedido_repo.save(pedido)
    expect(pedido_repo.find(pedido_creado.id).id_repartidor).to eq(repartidor.id)
  end

  it 'buscar pedidos por repartidor devuelve lista con pedidos vacia' do
    pedidos = pedido_repo.find_by_id_repartidor(repartidor.id)
    expect(pedidos.length).to eq(0)
  end

  it 'buscar pedidos por repartidor devuelve lista con pedidos' do
    pedido.asignar_repartidor(repartidor)
    pedido_repo.save(pedido)
    pedidos = pedido_repo.find_by_id_repartidor(repartidor.id)
    expect(pedidos.length).to eq(1)
    expect(pedidos.first.id_repartidor).to eq(repartidor.id)
  end

  it 'obtener calificacion de pedido' do
    pedido_repo.save(pedido)
    calificacion = Calificacion.new(pedido.id, 5)
    calificacion_repo.save(calificacion)

    expect(pedido_repo.find(pedido.id).calificacion.puntuacion).to eq(5)
  end

  it 'buscar pedidos por repartidor en camino devuelve lista con 1 pedido' do
    pedido = Pedido.new(menu, repartidor.id, EstadoPedido::EN_CAMINO)
    pedido_repo.save(pedido)

    pedidos = pedido_repo.find_by_id_repartidor_en_camino(repartidor.id)

    expect(pedidos.length).to eq(1)
    expect(pedidos.first.id_repartidor).to eq(repartidor.id)
    expect(pedidos.first.estado).to eq(EstadoPedido::EN_CAMINO)
  end

  it 'buscar pedidos por repartidor en camino devuelve lista con 3 pedidos' do
    pedidos_guardados = []
    (1..3).each do |_|
      pedido = Pedido.new(menu, repartidor.id, EstadoPedido::EN_CAMINO)
      pedidos_guardados.append(pedido_repo.save(pedido))
    end

    pedidos = pedido_repo.find_by_id_repartidor_en_camino(repartidor.id)

    expect(pedidos.length).to eq(pedidos_guardados.length)

    pedidos_expected = pedidos_guardados.map {
      |pedido| have_attributes(id: pedido.id,
                                    menu: have_attributes(
                                      id: pedido.menu.id,
                                      nombre: pedido.menu.nombre,
                                      precio: pedido.menu.precio
                                    ),
                                    id_repartidor: pedido.id_repartidor,
                                    estado: pedido.estado,
                                    calificacion: pedido.calificacion
      )}

    expect(pedidos).to match_array(pedidos_expected)
  end

  it 'pedido se guarda con el clima si estaba lloviendo' do
    pedido = Pedido.new(menu, nil, EstadoPedido::RECIBIDO, nil, nil, true)
    pedido_repo.save(pedido)

    pedido = pedido_repo.find(pedido.id)

    expect(pedido.esta_lloviendo).to be true
  end

  context 'no hay pedidos' do
    it 'obtener pedido inexistente lanza un error' do
      pedido_repo.delete_all
      expect { pedido_repo.find(1) }.to raise_error(ObjectNotFound)
    end
  end

end
