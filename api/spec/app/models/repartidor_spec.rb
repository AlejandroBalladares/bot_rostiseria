require 'spec_helper'

describe Repartidor do
  context 'pedidos asignados' do
    let(:menu_1) { Menu.new(1, "Menu individual", 100)}
    let(:menu_2) { Menu.new(2, "Menu parejas", 175, 2)}
    let(:menu_3) { Menu.new(3, "Menu familiar", 250, 3)}

    it 'cuando es creado, la mochila tiene peso 0' do
      repartidor = described_class.new('pipo', 3124)
      expect(repartidor.mochila.peso).to eq(0)
    end

    it 'cuando se le asigna 1 pedido individual, la mochila tiene peso 1' do
      repartidor = described_class.new('pipo', 3124)
      repartidor.asignar_pedido(Pedido.new(menu_1, repartidor.id, EstadoPedido::EN_CAMINO))
      expect(repartidor.mochila.peso).to eq(1)
    end

    it 'cuando se le asigna 1 pedido de pareja, la mochila tiene peso 2' do
      repartidor = described_class.new('pipo', 3124)
      repartidor.asignar_pedido(Pedido.new(menu_2, repartidor.id, EstadoPedido::EN_CAMINO))
      expect(repartidor.mochila.peso).to eq(2)
    end

    it 'cuando se le asigna 1 pedido familiar, la mochila tiene peso 3' do
      repartidor = described_class.new('pipo', 3124)
      repartidor.asignar_pedido(Pedido.new(menu_3, repartidor.id, EstadoPedido::EN_CAMINO))
      expect(repartidor.mochila.peso).to eq(3)
    end

    it 'cuando se le asigna 1 pedido familiar y un pedido individual devuelve un error' do
      repartidor = described_class.new('pipo', 3124)
      repartidor.asignar_pedido(Pedido.new(menu_3, repartidor.id, EstadoPedido::EN_CAMINO))
      expect { repartidor.asignar_pedido(Pedido.new(menu_1, repartidor.id, EstadoPedido::EN_CAMINO)) }.to raise_error(MochilaLlenaError)
    end

    it 'cuando repartidor tiene asignado 1 pedido individual y 1 pedido pareja, si se le asigna un pedido individual devuelve un error' do
      repartidor = described_class.new('pipo', 3124)
      repartidor.asignar_pedido(Pedido.new(menu_1, repartidor.id, EstadoPedido::EN_CAMINO))
      repartidor.asignar_pedido(Pedido.new(menu_2, repartidor.id, EstadoPedido::EN_CAMINO))
      expect { repartidor.asignar_pedido(Pedido.new(menu_1, repartidor.id, EstadoPedido::EN_CAMINO)) }.to raise_error(MochilaLlenaError)
    end

  end

  context 'calcular comision' do
    let(:repartidor) { described_class.new('pepe', 3124) }
    let(:menu_1) { Menu.new(1, "Menu individual", 100)}
    let(:menu_2) { Menu.new(2, "Menu parejas", 175)}

    it 'calcular comisiones sin pedidos entregados' do
      expect(repartidor.calcular_comisiones([])).to eq(0)
    end

    it 'calcular comisiones con 1 pedido con menu 1 entregado con calificacion media' do
      calificacion = Calificacion.new(1, 3)
      pedido = Pedido.new(menu_1, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(5)
    end

    it 'calcular comisiones con 1 pedido con menu 1 entregado con calificacion baja' do
      calificacion = Calificacion.new(1, 1)
      pedido = Pedido.new(menu_1, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(menu_1.precio * 3 / 100)
    end

    it 'calcular comisiones con 1 pedido con menu 1 entregado con calificacion alta' do
      calificacion = Calificacion.new(1, 5)
      pedido = Pedido.new(menu_1, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(7)
    end

    it 'calcular comisiones con 1 pedido con menu 1 entregado con calificacion alta y 1 pedido con menu 1 entregado con calificacion media' do
      calificacion = Calificacion.new(1, 5)
      pedido = Pedido.new(menu_1, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      calificacion_2 = Calificacion.new(2, 3)
      pedido_2 = Pedido.new(menu_1, repartidor.id, EstadoPedido::ENTREGADO, 2, calificacion_2)
      expect(repartidor.calcular_comisiones([pedido, pedido_2])).to eq(12)
    end

    it 'calcular comisiones con 1 pedido con menu 2 entregado con calificacion media' do
      calificacion = Calificacion.new(1, 3)
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(8.75)
    end

    it 'calcular comisiones con 1 pedido con menu 2 entregado con calificacion baja' do
      calificacion = Calificacion.new(1, 1)
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(5.25)
    end

    it 'calcular comisiones con 1 pedido con menu 2 entregado con calificacion alta' do
      calificacion = Calificacion.new(1, 5)
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion)
      expect(repartidor.calcular_comisiones([pedido])).to eq(12.25)
    end

    it 'calcular comisiones cuando llueve suma 1% al calculo de la comision del pedido con calificacion alta' do
      calificacion = Calificacion.new(1, 5)
      esta_lloviendo = true
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion, esta_lloviendo)
      expect(repartidor.calcular_comisiones([pedido])).to eq(14.0)
    end

    it 'calcular comisiones cuando llueve suma 1% al calculo de la comision del pedido con calificacion media' do
      calificacion = Calificacion.new(1, 3)
      esta_lloviendo = true
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion, esta_lloviendo)
      expect(repartidor.calcular_comisiones([pedido])).to eq(10.5)
    end

    it 'calcular comisiones cuando llueve suma 1% al calculo de la comision del pedido con calificacion baja' do
      calificacion = Calificacion.new(1, 1)
      esta_lloviendo = true
      pedido = Pedido.new(menu_2, repartidor.id, EstadoPedido::ENTREGADO, 1, calificacion, esta_lloviendo)
      expect(repartidor.calcular_comisiones([pedido])).to eq(7.0)
    end
  end

  context 'espacio en la mochila' do
    let(:menu_1) { Menu.new(1, "Menu individual", 100)}

    it 'tiene espacio en la mochila' do
      repartidor = described_class.new('pepe', 3124)
      pedido = Pedido.new(menu_1, repartidor.id, EstadoPedido::EN_CAMINO)
      expect(repartidor.tiene_espacio_en_la_mochila?(pedido)).to be true
    end
  end

end
