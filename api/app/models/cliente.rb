class Cliente
  attr_reader :nombre, :direccion, :telefono, :id_telegram
  attr_accessor :id

  def initialize(nombre, direccion, telefono, id_telegram, id = nil)
    @nombre = nombre
    @direccion = direccion
    @telefono = telefono
    @id_telegram = id_telegram
    @id = id
    validar!
  end

  private

  def validar!
    raise ClienteInvalidoError, 'nombre es obligatorio' if esta_vacio?(@nombre)
    raise ClienteInvalidoError, 'direccion es obligatorio' if esta_vacio?(@direccion)
    raise ClienteInvalidoError, 'telefono es obligatorio' if esta_vacio?(@telefono)
  end

  def esta_vacio?(parametro)
    (parametro.nil? || parametro == '')
  end
end
