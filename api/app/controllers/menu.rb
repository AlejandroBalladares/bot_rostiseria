WebTemplate::App.controllers :menus, :provides => [:json] do
  get :index do
    menus = menu_repo.all
    menus_to_json menus
  end
end
