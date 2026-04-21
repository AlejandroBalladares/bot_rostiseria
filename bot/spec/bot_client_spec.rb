require 'spec_helper'
require 'web_mock'
require 'stub_helper'

require "#{File.dirname(__FILE__)}/../app/bot_client"

describe 'BotClient' do
  token = 'fake_token'

  it 'should get a /version message and respond with current version' do
    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /equipo message and respond with the name of the team' do
    when_i_send_text(token, '/equipo')
    then_i_get_text(token, 'Equipo Praga')

    app = BotClient.new(token)

    app.run_once
  end

  it '/registrar con datos correctos devuelve mensaje exitoso' do
    web_api_stub_post(201, 'direccion' => 'Calle Falsa 123', 'nombre' => 'Pepe', 'telefono' => '1133223322', 'id_telegram' => 141_733_544)

    when_i_send_text(token, '/registrar Pepe,Calle Falsa 123,1133223322')
    then_i_get_text(token, 'Te registraste correctamente! Ya podés empezar a hacer tu pedido.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/registrar con datos existentes devuelve mensaje de error' do
    web_api_stub_post(409, 'direccion' => 'Calle Falsa 123', 'nombre' => 'Pepe', 'telefono' => '1133223322', 'id_telegram' => 141_733_544)

    when_i_send_text(token, '/registrar Pepe,Calle Falsa 123,1133223322')
    then_i_get_text(token, 'Ya estás registrado.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/registrar sin parámetros devuelve mensaje de error' do
    web_api_stub_post(400, 'direccion' => '', 'nombre' => '', 'telefono' => '', 'id_telegram' => 141_733_544)

    when_i_send_text(token, '/registrar')
    then_i_get_text(token, 'Registro fallido. Debe ingresar /registrar <nombre>,<dirección>,<teléfono>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/registrar solo con el nombre devuelve mensaje de error' do
    web_api_stub_post(400, 'direccion' => '', 'nombre' => '', 'telefono' => '', 'id_telegram' => 141_733_544)

    when_i_send_text(token, '/registrar Pepe')
    then_i_get_text(token, 'Registro fallido. Debe ingresar /registrar <nombre>,<dirección>,<teléfono>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/registrar con nombre y resto de parametros vacios devuelve mensaje de error' do
    web_api_stub_post(400, 'direccion' => '', 'nombre' => 'Pepe', 'telefono' => '', 'id_telegram' => 141_733_544)

    when_i_send_text(token, '/registrar Pepe,,')
    then_i_get_text(token, 'Registro fallido. Debe ingresar /registrar <nombre>,<dirección>,<teléfono>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedir con numero de menu existente' do
    web_api_stub_post(201, '{"id_menu":1, "id_telegram": 141733544}', 'pedidos', { 'id_pedido': 10 }.to_json)

    when_i_send_text(token, '/pedir 1')
    then_i_get_text(token, 'Gracias por tu pedido. Consulta el estado de tu pedido con /pedido 10')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedir con numero de menu inexistente' do
    web_api_stub_post(404, '{"id_menu":99999, "id_telegram": 141733544}', 'pedidos')

    when_i_send_text(token, '/pedir 99999')
    then_i_get_text(token, 'Pedido fallido, el menu seleccionado no existe. Debe ingresar /pedir <numero_menu>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedir con numero de menu faltante' do
    web_api_stub_post(400, '{"id_menu":, "id_telegram": 141733544}', 'pedidos')

    when_i_send_text(token, '/pedir')
    then_i_get_text(token, 'Pedido fallido. Debe ingresar /pedir <numero_menu>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedir mas de un menu es invalido' do
    web_api_stub_post(400, '{"id_menu":1,2, "id_telegram": 141733544}', 'pedidos')

    when_i_send_text(token, '/pedir 1,2')
    then_i_get_text(token, 'Pedido fallido. Debe ingresar /pedir <numero_menu>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/menu devuelve la lista de menues disponibles' do
    web_api_stub_get(200, 'menus', [{ id: 1, nombre: 'Menu individual', precio: 100 }, { id: 2, nombre: 'Menu parejas', precio: 175 }, { id: 3, nombre: 'Menu familiar', precio: 250 }].to_json)

    when_i_send_text(token, '/menu')
    then_i_get_text(token, "1. Menu individual ($100)\n2. Menu parejas ($175)\n3. Menu familiar ($250)")

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido en estado recibido devuelve el estado correcto' do
    web_api_stub_get(200, 'pedidos/1', { id: 1, estado: 'RECIBIDO' }.to_json)

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Su pedido fue recibido, en unos instantes comenzará su preparación')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido en estado en preparacion devuelve el estado correcto' do
    web_api_stub_get(200, 'pedidos/1', { id: 1, estado: 'EN_PREPARACION' }.to_json)

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Su pedido esta en preparación')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido en espera devuelve el estado correcto' do
    web_api_stub_get(200, 'pedidos/1', { id: 1, estado: 'EN_ESPERA' }.to_json)

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Su pedido esta en espera, se le asignará un repartidor cuando esté disponible')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido en camino devuelve el estado correcto' do
    web_api_stub_get(200, 'pedidos/1', { id: 1, estado: 'EN_CAMINO' }.to_json)

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Su pedido esta en camino, llegará a su domicilio en los proximos minutos')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido entregado devuelve el estado correcto' do
    web_api_stub_get(200, 'pedidos/1', { id: 1, estado: 'ENTREGADO' }.to_json)

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Su pedido ya fue entregado, esperamos que lo haya disfrutado')

    app = BotClient.new(token)

    app.run_once
  end

  it '/pedido de pedido inexistente devuelve error' do
    web_api_stub_get(404, 'pedidos/1')

    when_i_send_text(token, '/pedido 1')
    then_i_get_text(token, 'Consultar estado fallido, el pedido no existe. Debe ingresar /pedido <id_pedido>')

    app = BotClient.new(token)

    app.run_once
  end

  it '/calificar un pedido entregado' do
    web_api_stub_post(201, '{"puntuacion": 3, "id_telegram": 141733544}', 'pedidos/1/calificaciones')

    when_i_send_text(token, '/calificar 1,3')
    then_i_get_text(token, 'Pedido calificado con éxito!')

    app = BotClient.new(token)

    app.run_once
  end

  it '/calificar un pedido no entregado' do
    web_api_stub_post(400, '{"puntuacion": 3, "id_telegram": 141733544}', 'pedidos/1/calificaciones', '{"codigo_error": "CALIFICACION_ESTADO_INVALIDO"}')

    when_i_send_text(token, '/calificar 1,3')
    then_i_get_text(token, 'Calificación fallida. Sólo se pueden calificar pedidos entregados.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/calificar un pedido con puntuacion menor a 1 devuelve error' do
    web_api_stub_post(400, '{"puntuacion": 0, "id_telegram": 141733544}', 'pedidos/1/calificaciones', '{"codigo_error": "CALIFICACION_PUNTAJE_INVALIDO"}')

    when_i_send_text(token, '/calificar 1,0')
    then_i_get_text(token, 'Calificación fallida. La puntuación debe ser un número entre 1 y 5.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/calificar un pedido con puntuacion mayor a 5 devuelve error' do
    web_api_stub_post(400, '{"puntuacion": 6, "id_telegram": 141733544}', 'pedidos/1/calificaciones', '{"codigo_error": "CALIFICACION_PUNTAJE_INVALIDO"}')

    when_i_send_text(token, '/calificar 1,6')
    then_i_get_text(token, 'Calificación fallida. La puntuación debe ser un número entre 1 y 5.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/calificar un pedido con un usuario que no lo pidió devuelve error' do
    web_api_stub_post(409, '{"puntuacion": 5, "id_telegram": 141733544}', 'pedidos/1/calificaciones')

    when_i_send_text(token, '/calificar 1,5')
    then_i_get_text(token, 'Calificar pedido fallido, el pedido no pertenece al usuario.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/cancelar un pedido en estado recibido' do
    web_api_stub_delete(200, 'pedidos/1/cancelaciones', { id: 1, estado: 'RECIBIDO', id_repartidor: nil }.to_json)

    when_i_send_text(token, '/cancelar 1')
    then_i_get_text(token, 'Pedido cancelado con éxito.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/cancelar un pedido en estado en preparacion' do
    web_api_stub_delete(200, 'pedidos/1/cancelaciones', { id: 1, estado: 'EN_PREPARACION', id_repartidor: nil }.to_json)

    when_i_send_text(token, '/cancelar 1')
    then_i_get_text(token, 'Pedido cancelado con éxito.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/cancelar un pedido en estado en camino' do
    web_api_stub_delete(400, 'pedidos/1/cancelaciones', { id: 1, estado: 'EN_CAMINO', id_repartidor: nil }.to_json)

    when_i_send_text(token, '/cancelar 1')
    then_i_get_text(token, 'Cancelacion fallida. Solo es posible cancelar el pedido cuando fue recibido o está en preparación.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/cancelar un pedido en estado en espera' do
    web_api_stub_delete(400, 'pedidos/1/cancelaciones', { id: 1, estado: 'EN_ESPERA', id_repartidor: nil }.to_json)

    when_i_send_text(token, '/cancelar 1')
    then_i_get_text(token, 'Cancelacion fallida. Solo es posible cancelar el pedido cuando fue recibido o está en preparación.')

    app = BotClient.new(token)

    app.run_once
  end

  it '/cancelar un pedido en estado entregado' do
    web_api_stub_delete(400, 'pedidos/1/cancelaciones', { id: 1, estado: 'ENTREGADO', id_repartidor: nil }.to_json)

    when_i_send_text(token, '/cancelar 1')
    then_i_get_text(token, 'Cancelacion fallida. Solo es posible cancelar el pedido cuando fue recibido o está en preparación.')

    app = BotClient.new(token)

    app.run_once
  end
end
