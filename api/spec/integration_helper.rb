# rubocop:disable all
require 'spec_helper'
require_relative './factories/user_factory'

RSpec.configure do |config|
  config.include UserFactory
  config.before :each do
    Persistence::Repositories::ClienteRepository.new.delete_all
    Persistence::Repositories::PedidoRepository.new.delete_all
    Persistence::Repositories::RepartidorRepository.new.delete_all
    Persistence::Repositories::CalificacionRepository.new.delete_all
  end
end
