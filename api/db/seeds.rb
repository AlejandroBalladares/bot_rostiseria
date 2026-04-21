require_relative '../app/models/menu'

menu_repository = Persistence::Repositories::MenuRepository.new
unless menu_repository.all.count.positive?
	menu1 = Menu.new(1 , 'Menu individual', 100, 1)
	menu2 = Menu.new(2 , 'Menu parejas', 175, 2)
	menu3 = Menu.new(3 , 'Menu familiar', 250, 3)
	menu_repository.save menu1
	menu_repository.save menu2
	menu_repository.save menu3
end
