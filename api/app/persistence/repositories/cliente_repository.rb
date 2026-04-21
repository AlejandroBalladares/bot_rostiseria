module Persistence
  module Repositories
    class ClienteRepository < AbstractRepository
      self.table_name = :clientes
      self.model_class = 'Cliente'

      def find_by_id_telegram(id_telegram)
        dataset.where(id_telegram: id_telegram).map { |row| load_object(row) }.first
      end

      protected

      def load_object(a_hash)
        Cliente.new(a_hash[:nombre], a_hash[:direccion], a_hash[:telefono], a_hash[:id_telegram], a_hash[:id])
      end

      def changeset(cliente)
        {
          nombre: cliente.nombre,
          direccion: cliente.direccion,
          telefono: cliente.telefono,
          id_telegram: cliente.id_telegram
        }
      end

      def insert(a_record)
        begin
          id = dataset.insert(changeset(a_record))
          a_record.id = id
          a_record
        rescue Sequel::UniqueConstraintViolation
          raise ClienteYaRegistradoError
        end
      end
    end
  end
end
