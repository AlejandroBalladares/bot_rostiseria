require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/models/calificacion"
require "#{File.dirname(__FILE__)}/models/web_api"
require "#{File.dirname(__FILE__)}/models/pedido"
require "#{File.dirname(__FILE__)}/models/errors/cliente_ya_registrado_error"
require "#{File.dirname(__FILE__)}/models/errors/registrar_cliente_error"
require "#{File.dirname(__FILE__)}/models/errors/pedir_menu_error"
require "#{File.dirname(__FILE__)}/models/errors/pedir_menu_inexistente_error"
require "#{File.dirname(__FILE__)}/views/pedir_pedido_view"
require "#{File.dirname(__FILE__)}/views/menu_view"
require "#{File.dirname(__FILE__)}/views/estado_pedido_view"
require "#{File.dirname(__FILE__)}/models/errors/calificar_pedido_error"
require "#{File.dirname(__FILE__)}/models/errors/obtener_estado_pedido_error"
require "#{File.dirname(__FILE__)}/models/errors/obtener_menus_error"
require "#{File.dirname(__FILE__)}/models/errors/cancelar_pedido_error"
require "#{File.dirname(__FILE__)}/models/errors/cancelar_pedido_estado_invalido_error"
require "#{File.dirname(__FILE__)}/models/errors/calificar_pedido_estado_invalido_error"
require "#{File.dirname(__FILE__)}/models/errors/calificar_pedido_puntaje_invalido_error"
require "#{File.dirname(__FILE__)}/models/errors/obtener_estado_pedido_inexistente_error"
require "#{File.dirname(__FILE__)}/models/errors/calificar_pedido_usuario_invalido_error"

class Routes
  @logger = SemanticLogger['Routes']
  include Routing

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
  end

  on_message '/version' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: Version.current)
  end

  on_message '/equipo' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Equipo Praga')
  end

  on_message_pattern %r{/registrar(?: (?<nombre>.*),(?<direccion>.*),(?<telefono>.*))?} do |bot, message, args|
    RegistrarClienteWebApi.instance.registrar(args['nombre'], args['direccion'], args['telefono'], message.from.id)

    bot.api.send_message(chat_id: message.chat.id, text: 'Te registraste correctamente! Ya podés empezar a hacer tu pedido.')
  rescue ClienteYaRegistradoError
    bot.api.send_message(chat_id: message.chat.id, text: 'Ya estás registrado.')
  rescue RegistrarClienteError
    bot.api.send_message(chat_id: message.chat.id, text: 'Registro fallido. Debe ingresar /registrar <nombre>,<dirección>,<teléfono>')
  end

  on_message_pattern %r{/pedir(?: (?<id_menu>.*))?} do |bot, message, args|
    @logger.info message.to_s
    begin
      pedido = PedirPedidoWebApi.instance.pedir(args['id_menu'], message.from.id)
      pedir_pedido_view = PedirPedidoView.new(pedido)

      bot.api.send_message(chat_id: message.chat.id, text: pedir_pedido_view.mensaje)
    rescue PedirMenuInexistenteError
      bot.api.send_message(chat_id: message.chat.id, text: 'Pedido fallido, el menu seleccionado no existe. Debe ingresar /pedir <numero_menu>')
    rescue PedirMenuError
      bot.api.send_message(chat_id: message.chat.id, text: 'Pedido fallido. Debe ingresar /pedir <numero_menu>')
    end
  end

  on_message '/menu' do |bot, message|
    menus = MenuWebApi.instance.menu

    menu_view = MenuView.new(menus)

    bot.api.send_message(chat_id: message.chat.id, text: menu_view.mensaje)
  rescue ObtenerMenusError
    bot.api.send_message(chat_id: message.chat.id, text: 'Error al obtener menus.')
  end

  on_message_pattern %r{/pedido(?: (?<id_menu>.*))?} do |bot, message, args|
    @logger.info message.to_s
    estado_pedido = EstadoPedidoWebApi.instance.estado_pedido(args['id_menu'])
    estado_pedido_view = EstadoPedidoView.new(estado_pedido)

    bot.api.send_message(chat_id: message.chat.id, text: estado_pedido_view.mensaje)
  rescue ObtenerEstadoPedidoInexistenteError
    bot.api.send_message(chat_id: message.chat.id, text: 'Consultar estado fallido, el pedido no existe. Debe ingresar /pedido <id_pedido>')
  rescue ObtenerEstadoPedidoError
    bot.api.send_message(chat_id: message.chat.id, text: 'Consultar estado fallido. Debe ingresar /pedido <id_pedido>')
  end

  on_message_pattern %r{/calificar(?: (?<id_pedido>.*),(?<puntuacion>.*))?} do |bot, message, args|
    @logger.info message.to_s
    begin
      CalificarWebApi.instance.calificar(args['id_pedido'], args['puntuacion'], message.from.id)

      bot.api.send_message(chat_id: message.chat.id, text: 'Pedido calificado con éxito!')
    rescue CalificarPedidoUsuarioInvalidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Calificar pedido fallido, el pedido no pertenece al usuario.')
    rescue CalificarPedidoEstadoInvalidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Calificación fallida. Sólo se pueden calificar pedidos entregados.')
    rescue CalificarPedidoPuntajeInvalidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Calificación fallida. La puntuación debe ser un número entre 1 y 5.')
    rescue CalificarPedidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Calificación fallida. Debe ingresar /calificar <id_pedido>,<calificacion>')
    end
  end

  on_message_pattern %r{/cancelar(?: (?<id_pedido>.*))?} do |bot, message, args|
    @logger.info message.to_s
    begin
      CancelarWebApi.instance.cancelar(args['id_pedido'])

      bot.api.send_message(chat_id: message.chat.id, text: 'Pedido cancelado con éxito.')
    rescue CancelarPedidoEstadoInvalidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Cancelacion fallida. Solo es posible cancelar el pedido cuando fue recibido o está en preparación.')
    rescue CancelarPedidoError
      bot.api.send_message(chat_id: message.chat.id, text: 'Cancelación fallida. Debe ingresar /cancelar <id_pedido>')
    end
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
