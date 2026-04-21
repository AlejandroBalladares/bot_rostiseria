require 'spec_helper'

describe Mochila do
  context 'peso mochila' do
    let(:menu_individual) { Menu.new(1, 'Menu individual', 100, 1) }
    let(:menu_pareja) { Menu.new(2, 'Menu pareja', 100, 2) }
    let(:menu_familiar) { Menu.new(3, 'Menu familiar', 100, 3) }

    it 'peso de la mochila inicialmente vacia es 0' do
      mochila = described_class.new([])
      expect(mochila.peso).to eq(0)
    end

    it 'peso de la mochila inicialmente vacia es 1 al agregar un pedido individual' do
      mochila = described_class.new([])
      mochila.agregar_pedido(Pedido.new(menu_individual, nil, EstadoPedido::EN_CAMINO))
      expect(mochila.peso).to eq(1)
    end

    it 'peso de la mochila inicialmente vacia es 2 al agregar un pedido pareja' do
      mochila = described_class.new([])
      mochila.agregar_pedido(Pedido.new(menu_pareja, nil, EstadoPedido::EN_CAMINO))
      expect(mochila.peso).to eq(2)
    end

    it 'peso de la mochila inicialmente vacia es 3 al agregar un pedido familiar' do
      mochila = described_class.new([])
      mochila.agregar_pedido(Pedido.new(menu_familiar, nil, EstadoPedido::EN_CAMINO))
      expect(mochila.peso).to eq(3)
    end

    it 'peso de la mochila inicialmente con un pedido individual es 3 al agregar un pedido de pareja' do
      mochila = described_class.new([Pedido.new(menu_individual, nil, EstadoPedido::EN_CAMINO)])
      mochila.agregar_pedido(Pedido.new(menu_pareja, nil, EstadoPedido::EN_CAMINO))
      expect(mochila.peso).to eq(3)
    end

    it 'hay espacio disponible' do
      mochila = described_class.new([Pedido.new(menu_individual, nil, EstadoPedido::EN_CAMINO)])
      expect(mochila.hay_espacio?(Pedido.new(menu_individual, nil, EstadoPedido::EN_CAMINO))).to be true
    end
  end

  context 'mochila llena' do
    let(:menu_individual) { Menu.new(1, 'Menu individual', 100, 1) }
    let(:menu_familiar) { Menu.new(3, 'Menu familiar', 100, 3) }

    it 'mochila con pedido familiar devuelve error al agregar un pedido individual' do
      mochila = described_class.new([Pedido.new(menu_familiar, nil, EstadoPedido::EN_CAMINO)])
      expect { mochila.agregar_pedido(Pedido.new(menu_individual, nil, EstadoPedido::EN_CAMINO)) }.to raise_error(MochilaLlenaError)
    end
  end
end
