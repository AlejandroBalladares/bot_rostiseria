# language: es

Característica: Registracion de repartidor

  Escenario: US4-01 Registracion exitosa
    Cuando intento registrar un repatidor con nombre 'pepe' y documento '42149084'
    Entonces recibo el numero de identificación del repartidor creado

  @siguiente_iteracion @wip
  Escenario: US4-02 Registracion sin campos
    Cuando intento registrar un repatidor sin nombre y sin documento
    Entonces recibo un mensaje de error

  @siguiente_iteracion @wip
  Escenario: US4-03 Registracion con campos faltantes
    Cuando intento registrar un repatidor con nombre 'pepe' y sin documento
    Entonces recibo un mensaje de error
