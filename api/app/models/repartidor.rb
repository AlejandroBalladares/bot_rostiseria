class Repartidor
  NOTA_MEDIA = 3
  NOTA_BAJA = 1

  PORCENTAJE_COMISION_MEDIA = 5
  PORCENTAJE_COMISION_BAJA = 3
  PORCENTAJE_COMISION_ALTA = 7

  PORCENTAJE_EXTRA_POR_LLUVIA = 1

  attr_reader :nombre, :documento, :mochila
  attr_accessor :id

  def initialize(nombre, documento, id = nil, mochila = Mochila.new([]))
    @id = id
    @nombre = nombre
    @documento = documento
    @mochila = mochila
  end

  def calcular_comisiones(pedidos)
    return 0 if pedidos.empty?
    pedidos.map { |pedido| calcular_comision_pedido(pedido) }.reduce(:+)
  end

  def asignar_pedido(pedido)
    @mochila.agregar_pedido(pedido)
  end

  def carga_actual
    @mochila.peso
  end

  def tiene_espacio_en_la_mochila?(pedido)
    @mochila.hay_espacio?(pedido)
  end

  private

  def calcular_comision_pedido(pedido)
    porcentaje_extra_por_lluvia = pedido.esta_lloviendo ? PORCENTAJE_EXTRA_POR_LLUVIA : 0

    porcentaje = if pedido.calificacion.nil?
      PORCENTAJE_COMISION_MEDIA
    else
      case pedido.calificacion.puntuacion
      when NOTA_MEDIA
       PORCENTAJE_COMISION_MEDIA
      when NOTA_BAJA
       PORCENTAJE_COMISION_BAJA
      else
       PORCENTAJE_COMISION_ALTA
      end
    end

    pedido.menu.precio * (porcentaje + porcentaje_extra_por_lluvia) / 100.0
  end
end
