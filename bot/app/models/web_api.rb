require 'semantic_logger'
require_relative 'menu'
require_relative 'estado_pedido'

class WebApi
  def initialize
    @base_url = ENV.fetch('API_URL', 'http://webapi.fake')
    @logger = SemanticLogger['WebApi']
    @header = { 'Content-Type' => 'application/json' }
  end
end

class RegistrarClienteWebApi < WebApi
  @instance = RegistrarClienteWebApi.new

  class << self
    attr_reader :instance
  end

  CLIENTE_CREADO = 201
  CLIENTE_YA_REGISTRADO = 409

  def registrar(nombre, direccion, telefono, id_telegram)
    @logger.info "Registrar con #{nombre} #{direccion} #{telefono} #{id_telegram}"
    begin
      respuesta = Faraday.post("#{@base_url}/clientes", "{\"nombre\": \"#{nombre}\", \"direccion\": \"#{direccion}\", \"telefono\": \"#{telefono}\", \"id_telegram\": #{id_telegram}}", @header)
    rescue StandardError => e
      @logger.info e.message
      raise RegistrarClienteError
    end

    case respuesta.status
    when CLIENTE_CREADO
      return
    when CLIENTE_YA_REGISTRADO
      raise ClienteYaRegistradoError
    else
      raise RegistrarClienteError
    end
  end
end

class PedirPedidoWebApi < WebApi
  @instance = PedirPedidoWebApi.new

  class << self
    attr_reader :instance
  end

  PEDIDO_CREADO = 201
  MENU_INEXISTENTE = 404

  def pedir(id_menu, id_telegram)
    @logger.info "Pedir con #{id_menu} de #{id_telegram}"
    begin
      respuesta = Faraday.post("#{@base_url}/pedidos", "{\"id_menu\":#{id_menu}, \"id_telegram\": #{id_telegram}}", @header)
    rescue StandardError => e
      @logger.info e.message
      raise PedirMenuError
    end

    case respuesta.status
    when PEDIDO_CREADO
      Pedido.new(JSON.parse(respuesta.body)['id_pedido'])
    when MENU_INEXISTENTE
      raise PedirMenuInexistenteError
    else
      raise PedirMenuError
    end
  end
end

class MenuWebApi < WebApi
  @instance = MenuWebApi.new

  class << self
    attr_reader :instance
  end

  MENUS_OBTENIDOS = 200

  def menu
    @logger.info 'Menu'
    begin
      respuesta = Faraday.get("#{@base_url}/menus")
    rescue StandardError => e
      @logger.info e.message
      raise ObtenerMenusError
    end

    case respuesta.status
    when MENUS_OBTENIDOS
      body = JSON.parse(respuesta.body)
      body.map { |menu| Menu.new(menu['id'], menu['nombre'], menu['precio']) }
    else
      raise ObtenerMenusError
    end
  end
end

class EstadoPedidoWebApi < WebApi
  @instance = EstadoPedidoWebApi.new

  class << self
    attr_reader :instance
  end

  ESTADO_PEDIDO_OBTENIDO = 200
  PEDIDO_INEXISTENTE = 404

  def estado_pedido(id_pedido)
    @logger.info "Pedido con #{id_pedido}"
    begin
      respuesta = Faraday.get("#{@base_url}/pedidos/#{id_pedido}")
    rescue StandardError => e
      @logger.info e.message
      raise ObtenerEstadoPedidoError
    end

    case respuesta.status
    when ESTADO_PEDIDO_OBTENIDO
      body = JSON.parse(respuesta.body)
      EstadoPedido.new(body['estado'])
    when PEDIDO_INEXISTENTE
      raise ObtenerEstadoPedidoInexistenteError
    else
      raise ObtenerEstadoPedidoError
    end
  end
end

class CalificarWebApi < WebApi
  @instance = CalificarWebApi.new

  class << self
    attr_reader :instance
  end

  CALIFICACION_CREADA = 201
  CALIFICAR_BAD_REQUEST = 400
  CALIFICAR_USUARIO_INVALIDO = 409

  def calificar(id_pedido, puntuacion, id_telegram)
    @logger.info "Calificación de pedido #{id_pedido} con #{puntuacion} de #{id_telegram}"
    begin
      respuesta = Faraday.post("#{@base_url}/pedidos/#{id_pedido}/calificaciones", "{\"puntuacion\": #{puntuacion}, \"id_telegram\": #{id_telegram}}", @header)
    rescue StandardError => e
      @logger.info e.message
      raise CalificarPedidoError
    end

    case respuesta.status
    when CALIFICACION_CREADA
      return
    when CALIFICAR_BAD_REQUEST
      manejar_bad_request(JSON.parse(respuesta.body)['codigo_error'])
    when CALIFICAR_USUARIO_INVALIDO
      raise CalificarPedidoUsuarioInvalidoError
    else
      raise CalificarPedidoError
    end
  end

  def manejar_bad_request(codigo_error)
    case codigo_error
    when 'CALIFICACION_ESTADO_INVALIDO'
      raise CalificarPedidoEstadoInvalidoError
    when 'CALIFICACION_PUNTAJE_INVALIDO'
      raise CalificarPedidoPuntajeInvalidoError
    else
      raise CalificarPedidoError
    end
  end
end

class CancelarWebApi < WebApi
  @instance = CancelarWebApi.new

  class << self
    attr_reader :instance
  end

  CANCELACION_EXITOSA = 200
  CANCELAR_PEDIDO_ESTADO_INVALIDO = 400

  def cancelar(id_pedido)
    @logger.info "Cancelar pedido #{id_pedido}"

    begin
      respuesta = Faraday.delete("#{@base_url}/pedidos/#{id_pedido}/cancelaciones")
    rescue StandardError => e
      @logger.info e.message
      raise CancelarPedidoError
    end

    case respuesta.status
    when CANCELACION_EXITOSA
      return
    when CANCELAR_PEDIDO_ESTADO_INVALIDO
      raise CancelarPedidoEstadoInvalidoError
    else
      raise CancelarPedidoError
    end
  end
end
