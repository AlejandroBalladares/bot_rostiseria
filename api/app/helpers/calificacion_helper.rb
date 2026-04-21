module WebTemplate
  class App
    module CalificacionHelper
      def calificacion_repo
        Persistence::Repositories::CalificacionRepository.new
      end

      def calificacion_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end

      def calificacion_to_json(calificacion)
        {
          id_pedido: calificacion.id_pedido,
          puntuacion: calificacion.puntuacion,
        }.to_json
      end

      def calificacion_puntaje_invalido_error_to_json
        { codigo_error: 'CALIFICACION_PUNTAJE_INVALIDO' }.to_json
      end

      def calificacion_estado_invalido_error_to_json
        { codigo_error: 'CALIFICACION_ESTADO_INVALIDO' }.to_json
      end
    end

    helpers CalificacionHelper
  end
end
