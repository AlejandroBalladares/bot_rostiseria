module Persistence
  module Repositories
    class RepartidorRepository < AbstractRepository
        self.table_name = :repartidores
        self.model_class = 'Repartidor'

        def first
          first = dataset.first
          return nil if first.nil?
          load_object first
        end

        def cantidad_pedidos_entregados(id_repartidor)
          pedidos = Repositories::PedidoRepository.new.find_by_id_repartidor_entregado(id_repartidor)
          pedidos.length
        end

        protected
  
        def load_object(a_hash)
          pedidos = Repositories::PedidoRepository.new.find_by_id_repartidor_en_camino(a_hash[:id])
          mochila = Mochila.new(pedidos)
          Repartidor.new(a_hash[:nombre], a_hash[:documento], a_hash[:id], mochila)
        end
  
        def changeset(repartidor)
          {
            nombre: repartidor.nombre,
            documento: repartidor.documento
          }
        end

        def insert(a_record)
          id = dataset.insert(changeset(a_record))
          a_record.id = id
          a_record
        end
    end
  end
end
