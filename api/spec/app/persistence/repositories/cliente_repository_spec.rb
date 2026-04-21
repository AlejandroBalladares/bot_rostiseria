require 'integration_helper'

describe Persistence::Repositories::ClienteRepository do
  let(:cliente_repo) { Persistence::Repositories::ClienteRepository.new }
  let(:cliente) { Cliente.new('Pepe', 'Calle Falsa 321', '321321', 543534) }
  let(:cliente_2) { Cliente.new('Maria', 'Calle Falsa 123', '3213243564', 543534) }

  it 'guarda un cliente' do
    cliente_repo.save(cliente)
    expect(cliente_repo.all.count).to eq(1)
  end

  it 'cliente ya registrado devuelve error' do
    cliente_repo.save(cliente)
    expect { cliente_repo.save(cliente_2) }.to raise_error(ClienteYaRegistradoError)
  end

  it 'obtener cliente por id telegram' do
    cliente_repo.save(cliente)
    expect(cliente_repo.find_by_id_telegram(cliente.id_telegram).id).to eq(cliente.id)
  end
end
