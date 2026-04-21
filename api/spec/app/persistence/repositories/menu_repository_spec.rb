require 'integration_helper'

describe Persistence::Repositories::MenuRepository do
  let(:menu_repo) { Persistence::Repositories::MenuRepository.new }

  it 'desc' do
    menu = Menu.new(4, "Menu ejecutivo", 500)
    menu_repo.save(menu)
    menu_guardado = menu_repo.find(menu.id)
    expect(menu_guardado.nombre).to eq(menu.nombre)
  end
end
