require 'spec_helper'

describe Pedido do
  context 'cuando es creado' do
    let(:menu) { Menu.new(1, 'Menu individual', 100) }
    it 'valido cuando tiene id de menú' do
      pedido = described_class.new(menu)
      expect(pedido).to be_an_instance_of(Pedido)
    end

    it 'su estado inicial es RECIBIDO' do
      pedido = described_class.new(menu)
      expect(pedido.estado).to eq(EstadoPedido::RECIBIDO)
    end
  end

  context 'cambio de estado' do
    let(:repartidor_repo) { Persistence::Repositories::RepartidorRepository.new }
    let(:asignador_pedidos) { AsignadorPedidos.new(repartidor_repo) }
    let(:menu) { Menu.new(1, 'Menu individual', 100) }

    it 'cuando estado es RECIBIDO el siguiente estado es EN_PREPARACION' do
      pedido = described_class.new(menu)
      pedido.siguiente_estado(asignador_pedidos)
      expect(pedido.estado).to eq(EstadoPedido::EN_PREPARACION)
    end

    it 'cuando estado es EN_PREPARACION el siguiente estado cuando no hay repartidores es EN_ESPERA' do
      pedido = described_class.new(menu)
      pedido.siguiente_estado(asignador_pedidos)
      pedido.siguiente_estado(asignador_pedidos)
      expect(pedido.estado).to eq(EstadoPedido::EN_ESPERA)
    end

    it 'cuando estado es EN_PREPARACION el siguiente estado cuando hay repartidores es EN_CAMINO' do
      repartidor_repo.save(Repartidor.new('Pepe', 321321))
      pedido = described_class.new(menu)
      pedido.siguiente_estado(asignador_pedidos)
      pedido.siguiente_estado(asignador_pedidos)
      expect(pedido.estado).to eq(EstadoPedido::EN_CAMINO)
    end

    it 'cuando estado es EN_CAMINO el siguiente estado es ENTREGADO' do
      repartidor_repo.save(Repartidor.new('Pepe', 321321))
      pedido = described_class.new(menu)
      pedido.siguiente_estado(asignador_pedidos)
      pedido.siguiente_estado(asignador_pedidos)
      pedido.siguiente_estado(asignador_pedidos)
      expect(pedido.estado).to eq('ENTREGADO')
    end
  end

  context 'estado de pedido depende de repartidores disponibles' do
    before(:each) do
      @repartidor_repo = Persistence::Repositories::RepartidorRepository.new
      @pedidos_repo = Persistence::Repositories::PedidoRepository.new
      @repartidor_repo.save(Repartidor.new('Pepe', 321321))
      @asignador_pedido = AsignadorPedidos.new(@repartidor_repo)
      @menu_individual = Menu.new(1, 'Menu individual', 100)
      @menu_pareja = Menu.new(2, 'Menu pareja', 200, 2)
    end

    it 'pedido con menu individual queda en estado EN_ESPERA si el único repartidor a asignar tiene 3 pedidos individuales' do
      (1..3).each do |_|
        menu = Menu.new(1, 'Menu Individual', 100, 1)
        pedido = Pedido.new(menu, nil, EstadoPedido::EN_PREPARACION)
        pedido.siguiente_estado(@asignador_pedido)
        @pedidos_repo.save(pedido)
      end

      pedido = Pedido.new(@menu_individual, nil, EstadoPedido::EN_PREPARACION)

      pedido.siguiente_estado(@asignador_pedido)
      expect(pedido.estado).to eq(EstadoPedido::EN_ESPERA)
    end

    it 'pedido con menu individual queda en estado EN_ESPERA si el único repartidor a asignar tiene 1 pedido individual y 1 pedido pareja' do
      pedido = Pedido.new(@menu_individual, nil, EstadoPedido::EN_PREPARACION)
      pedido.siguiente_estado(@asignador_pedido)
      @pedidos_repo.save(pedido)

      pedido = Pedido.new(@menu_pareja, nil, EstadoPedido::EN_PREPARACION)
      pedido.siguiente_estado(@asignador_pedido)
      @pedidos_repo.save(pedido)

      pedido = Pedido.new(@menu_individual, nil, EstadoPedido::EN_PREPARACION)

      pedido.siguiente_estado(@asignador_pedido)
      expect(pedido.estado).to eq(EstadoPedido::EN_ESPERA)
    end
  end

  context 'cancelable' do
    let(:menu) { Menu.new(1, 'Menu individual', 100, 1) }

    it 'pedido en estado recibido es cancelable' do
      pedido = described_class.new(menu, nil, EstadoPedido::RECIBIDO)
      expect(pedido.es_cancelable?).to be true
    end

    it 'pedido en estado en preparacion es cancelable' do
      pedido = described_class.new(menu, nil, EstadoPedido::EN_PREPARACION)
      expect(pedido.es_cancelable?).to be true
    end

    it 'pedido en estado en espera no es cancelable' do
      pedido = described_class.new(menu, nil, EstadoPedido::EN_ESPERA)
      expect(pedido.es_cancelable?).to be false
    end

    it 'pedido en estado en camino no es cancelable' do
      pedido = described_class.new(menu, nil, EstadoPedido::EN_CAMINO)
      expect(pedido.es_cancelable?).to be false
    end

    it 'pedido en estado entregado no es cancelable' do
      pedido = described_class.new(menu, nil, EstadoPedido::ENTREGADO)
      expect(pedido.es_cancelable?).to be false
    end
  end

  context 'calificable' do
    let(:menu) { Menu.new(1, 'Menu individual', 100, 1) }

    it 'pedido es calificable si esta en estado ENTREGADO' do
      pedido = Pedido.new(menu, nil, EstadoPedido::ENTREGADO)
      expect(pedido.es_calificable?).to be true
    end

    it 'pedido no es calificable si esta en estado RECIBIDO' do
      pedido = Pedido.new(menu, nil, EstadoPedido::RECIBIDO)
      expect(pedido.es_calificable?).to be false
    end

    it 'pedido no es calificable si esta en estado EN_PREPARACION' do
      pedido = Pedido.new(menu, nil, EstadoPedido::EN_PREPARACION)
      expect(pedido.es_calificable?).to be false
    end

    it 'pedido no es calificable si esta en estado EN_ESPERA' do
      pedido = Pedido.new(menu, nil, EstadoPedido::EN_ESPERA)
      expect(pedido.es_calificable?).to be false
    end

    it 'pedido no es calificable si esta en estado EN_CAMINO' do
      pedido = Pedido.new(menu, nil, EstadoPedido::EN_CAMINO)
      expect(pedido.es_calificable?).to be false
    end

  end

  it 'pedido pertenece a un cliente' do
    cliente = Cliente.new('Juan', 'Perez', 32132, 543543)
    pedido = Pedido.new(1, nil, EstadoPedido::RECIBIDO, nil, nil, false, cliente)
    expect(pedido.pertenece_a?(543543)).to be true
  end
end
