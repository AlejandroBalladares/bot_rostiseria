require 'spec_helper'
require "#{File.dirname(__FILE__)}/../app/models/web_api"

describe WebApi do
  after :each do
    WebMock.disable_net_connect!
  end

  before :each do
    WebMock.allow_net_connect!
    Faraday.post("#{ENV['API_URL']}/reset", {}.to_json, 'Content-Type' => 'application/json')
  end

  it 'registrar cliente exitoso' do
    expect { RegistrarClienteWebApi.instance.registrar('Pepe', 'Calle Falsa 123', '1133223322', 669) }.not_to raise_error
  end

  it 'pedir un pedido exitoso' do
    id_telegram = 141_733_544
    pedido = PedirPedidoWebApi.instance.pedir(1, id_telegram)
    expect(pedido).to be_a Pedido
  end

  it 'obtener menu exitoso' do
    menus = MenuWebApi.instance.menu
    expect(menus.empty?).to be false
    expect(menus.first).to be_a Menu
  end

  it 'pasar de estado un pedido' do
    id_telegram = 141_733_544
    pedido = PedirPedidoWebApi.instance.pedir(1, id_telegram)
    estado_pedido = EstadoPedidoWebApi.instance.estado_pedido(pedido.id)
    expect(estado_pedido.estado).to eq 'RECIBIDO'
  end

  it 'calificar un pedido' do
    id_telegram = 141_733_544
    pedido = PedirPedidoWebApi.instance.pedir(1, id_telegram)
    pasar_pedido_a_entregado(pedido.id)
    puntuacion = 5
    expect { CalificarWebApi.instance.calificar(pedido.id, puntuacion, id_telegram) }.not_to raise_error
  end

  it 'cancelar un pedido' do
    id_telegram = 141_733_544
    pedido = PedirPedidoWebApi.instance.pedir(1, id_telegram)

    expect { CancelarWebApi.instance.cancelar(pedido.id) }.not_to raise_error
  end
end

def pasar_pedido_a_entregado(id_pedido)
  Faraday.post("#{ENV['API_URL']}/repartidores", { nombre: 'Pepe', documento: 123_456 }.to_json, 'Content-Type' => 'application/json')
  3.times do
    Faraday.put("#{ENV['API_URL']}/pedidos/#{id_pedido}/estados", {}.to_json, 'Content-Type' => 'application/json')
  end
end
