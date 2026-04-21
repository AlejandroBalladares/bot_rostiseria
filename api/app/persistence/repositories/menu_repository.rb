module Persistence
  module Repositories
    class MenuRepository < AbstractRepository
      self.table_name = :menus
      self.model_class = 'Menu'

      def load_object(a_hash)
        Menu.new(a_hash[:id], a_hash[:nombre], a_hash[:precio], a_hash[:peso])
      end

      def changeset(menu)
        {
          id: menu.id,
          nombre: menu.nombre,
          precio: menu.precio,
          peso: menu.peso
        }
      end

      def insert(a_record)
        id = dataset.insert(changeset(a_record))
        a_record.id = id
        a_record
      end

      def update(a_record)
        find_dataset_by_id(a_record.id).update(changeset(a_record))
      end
    end
  end
end
