module Persistence
  module Repositories
    class CalificacionRepository < AbstractRepository
      self.table_name = :calificaciones
      self.model_class = 'Calificacion'

      def save(calificacion)
        if find_dataset_by_id(calificacion.id_pedido).first
          update(calificacion)
        else
          insert(calificacion)
        end
        calificacion
      end

      def find_by_id_pedido(id_pedido)
        found_record = dataset.first(id_pedido: id_pedido)
        return nil if found_record.nil?
        load_object found_record
      end

      protected

      def load_object(a_hash)
        Calificacion.new(a_hash[:id_pedido], a_hash[:puntuacion], a_hash[:id])
      end

      def changeset(calificacion)
        {
          id_pedido: calificacion.id_pedido,
          puntuacion: calificacion.puntuacion,
        }
      end

      def insert(calificacion)
        id = dataset.insert(changeset(calificacion))
        calificacion.id = id
        calificacion
      end

      def update(calificacion)
        find_dataset_by_id(calificacion.id).update(changeset(calificacion))
      end
    end
  end
end
