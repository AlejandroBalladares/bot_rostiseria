# rubocop:disable all
ENV['RACK_ENV'] = 'test'
ENV['ENABLE_RESET'] = 'true'
ENV['HABILITAR_CLIMA_API_MOCK'] = 'true'
ENV['USAR_CLIMA_API_MOCK'] = 'true'
ENV['LLUVIA_CLIMA_API_MOCK'] = 'false'

require File.expand_path("#{File.dirname(__FILE__)}/../../config/boot")

require 'rspec/expectations'

if ENV['BASE_URL']
  BASE_URL = ENV['BASE_URL']
else
  BASE_URL = 'http://localhost:3000'.freeze
  include Rack::Test::Methods
  def app
    Padrino.application
  end
end

def header
  {'Content-Type' => 'application/json'}
end

def reset_url
  "#{BASE_URL}/reset"
end

def crear_cliente_url
  "#{BASE_URL}/clientes"
end

def pedir_pedido_url
  "#{BASE_URL}/pedidos"
end

def menu_url
  "#{BASE_URL}/menus"
end

def crear_repartidor_url
  "#{BASE_URL}/repartidores"
end

def comisiones_repartidor_url(id_repartidor)
  "#{BASE_URL}/repartidores/#{id_repartidor}/comisiones"
end

def estado_pedido_url(id_pedido)
  "#{BASE_URL}/pedidos/#{id_pedido}"
end

def pasar_estado_pedido_url(id_pedido)
  "#{BASE_URL}/pedidos/#{id_pedido}/estados"
end

def calificar_pedido_url(id_pedido)
  "#{BASE_URL}/pedidos/#{id_pedido}/calificaciones"
end

def cancelar_pedido_url(id_pedido)
  "#{BASE_URL}/pedidos/#{id_pedido}/cancelaciones"
end

def clima_api_mock_url
  "#{BASE_URL}/clima"
end

Before do |_scenario|
  Faraday.post(reset_url)
  Faraday.put(clima_api_mock_url, { habilitar: true, lluvia: false }.to_json, header)
end
