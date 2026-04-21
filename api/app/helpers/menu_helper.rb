module WebTemplate
  class App
    module MenuHelper
      def menu_repo
        Persistence::Repositories::MenuRepository.new
      end

      def menus_to_json(menus)
        menus.map { |menu| atributos_menu(menu) }.to_json
      end

      private

      def atributos_menu(menu)
        {id: menu.id, nombre: menu.nombre, precio: menu.precio}
      end
    end

    helpers MenuHelper
  end
end
