require_relative '../models/clima_api'

module WebTemplate
  class App
    module PedidosHelper
      def pedidos_repo
        Persistence::Repositories::PedidoRepository.new
      end

      def pedidos_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end

      def pedido_to_json(pedido)
        id_repartidor = pedido.id_repartidor.nil? ? nil : pedido.id_repartidor
        {id: pedido.id, estado: pedido.estado, id_repartidor: id_repartidor}.to_json
      end

      def clima_api
        if ENV['USAR_CLIMA_API_MOCK'] == 'true'
          ClimaApiMock.new(ENV['LLUVIA_CLIMA_API_MOCK'] == 'true')
        else
          ClimaApiImpl.new
        end
      end
    end

    helpers PedidosHelper
  end
end
