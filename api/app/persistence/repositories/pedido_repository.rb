module Persistence
  module Repositories
    class PedidoRepository < AbstractRepository
      self.table_name = :pedidos
      self.model_class = 'Pedido'

      def find_by_id_repartidor(id_repartidor)
        dataset.where(id_repartidor: id_repartidor).map { |row| load_object(row) }
      end

      def find_by_id_repartidor_en_camino(id_repartidor)
        dataset.where(id_repartidor: id_repartidor, estado: EstadoPedido::EN_CAMINO).map { |row| load_object(row) }
      end

      def find_by_id_repartidor_entregado(id_repartidor)
        dataset.where(id_repartidor: id_repartidor, estado: EstadoPedido::ENTREGADO).map { |row| load_object(row) }
      end

      protected

      def load_object(a_hash)
        menu = MenuRepository.new.find(a_hash[:id_menu])
        calificacion = CalificacionRepository.new.find_by_id_pedido(a_hash[:id])
        id_repartidor = a_hash[:id_repartidor].nil? ? nil : a_hash[:id_repartidor]
        cliente = a_hash[:id_cliente].nil? ? nil : ClienteRepository.new.find(a_hash[:id_cliente])

        Pedido.new(menu, id_repartidor, a_hash[:estado], a_hash[:id], calificacion, a_hash[:lloviendo], cliente)
      end

      def changeset(pedido)
        {
          id_menu: pedido.menu.id,
          estado: pedido.estado,
          id_repartidor: pedido.id_repartidor.nil? ? nil : pedido.id_repartidor,
          lloviendo: pedido.esta_lloviendo,
          id_cliente: pedido.cliente.nil? ? nil : pedido.cliente.id
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
