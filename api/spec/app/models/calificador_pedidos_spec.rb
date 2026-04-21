require 'integration_helper'

describe CalificadorPedidos do
  let(:pedido) { Pedido.new(1) }

  it 'calificar un pedido con 2 devuelve una calificacion con 2' do
    calificacion = CalificadorPedidos.new( Persistence::Repositories::CalificacionRepository.new ).calificar(pedido.id, 2)
    expect(calificacion.puntuacion).to eq(2)
  end

  it 'calificar un pedido con 5 devuelve una calificacion con 5' do
    calificacion = CalificadorPedidos.new( Persistence::Repositories::CalificacionRepository.new ).calificar(pedido.id, 5)
    expect(calificacion.puntuacion).to eq(5)
  end

  it 'calificar un pedido con 0 devuelve un error' do
    expect { CalificadorPedidos.new( Persistence::Repositories::CalificacionRepository.new ).calificar(pedido.id, 0) }.to raise_error(CalificacionPuntajeInvalidoError)
  end

  it 'calificar un pedido con 6 devuelve un error' do
    expect { CalificadorPedidos.new( Persistence::Repositories::CalificacionRepository.new ).calificar(pedido.id, 6) }.to raise_error(CalificacionPuntajeInvalidoError)
  end
end
