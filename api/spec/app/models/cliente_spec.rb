require 'spec_helper'

describe Cliente do
  context 'cuando es creado' do
    it 'valido cuando tiene nombre, direccion, telefono y id de telegram' do
      cliente = described_class.new("Pepe", "Calle falsa 123", "12341234", 1234567890)
      expect(cliente).to be_an_instance_of(Cliente)
    end
    
    it 'invalido cuando no se especifica el nombre' do
      expect { described_class.new(nil, "Calle falsa 123", "12341234", 1234567890) }.to raise_error(ClienteInvalidoError, 'nombre es obligatorio')
    end

    it 'invalido cuando no se especifica la direccion' do
      expect { described_class.new("Pepe", nil, "12341234", 1234567890) }.to raise_error(ClienteInvalidoError, 'direccion es obligatorio')
    end

    it 'invalido cuando no se especifica el telefono' do
      expect { described_class.new("Pepe", "Calle falsa 123", nil, 1234567890) }.to raise_error(ClienteInvalidoError, 'telefono es obligatorio')
    end
  end
end
