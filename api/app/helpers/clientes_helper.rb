module WebTemplate
  class App
    module ClienteHelper
      def cliente_repo
        Persistence::Repositories::ClienteRepository.new
      end

      def cliente_params
        @body ||= request.body.read
        JSON.parse(@body).symbolize_keys
      end
    end

    helpers ClienteHelper
  end
end
