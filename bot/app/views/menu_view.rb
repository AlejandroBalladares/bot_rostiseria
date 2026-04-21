class MenuView
  def initialize(menus)
    @menus = menus
  end

  def mensaje
    @menus.map { |menu| "#{menu.id}. #{menu.nombre} ($#{menu.precio})" }.join("\n")
  end
end
