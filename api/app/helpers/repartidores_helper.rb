module WebTemplate
  class App
    module RepartidorHelper
      def repartidor_repo
        Persistence::Repositories::RepartidorRepository.new
      end

      def repartidor_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end
    end

    helpers RepartidorHelper
  end
end
