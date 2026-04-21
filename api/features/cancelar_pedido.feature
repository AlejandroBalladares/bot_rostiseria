# language: es

Característica: Cancelar pedido


  Escenario: US19-api-01 Como cliente quiero cancelar un pedido en estado recibido
    Dado que existe un pedido con id 1 en estado 'RECIBIDO'
    Cuando intento cancelar el pedido 1
    Entonces me devuelve el id del pedido borrado

  Escenario: US19-api-02 Como cliente quiero cancelar un pedido en estado en preparación
    Dado que existe un pedido con id 1 en estado 'EN_PREPARACION'
    Cuando intento cancelar el pedido 1
    Entonces me devuelve el id del pedido borrado

  Escenario: US25-api-01 Como cliente quiero cancelar un pedido en estado en espera
    Dado que existe un pedido con id 1 en estado 'EN_ESPERA'
    Cuando intento cancelar el pedido 1
    Entonces me devuelve un mensaje de error

  Escenario: US25-api-02 Como cliente quiero cancelar un pedido en estado en camino
    Dado que existe un pedido con id 1 en estado 'EN_CAMINO'
    Cuando intento cancelar el pedido 1
    Entonces me devuelve un mensaje de error

  Escenario: US25-api-03 Como cliente quiero cancelar un pedido en estado en entregado
    Dado que existe un pedido con id 1 en estado 'ENTREGADO'
    Cuando intento cancelar el pedido 1
    Entonces me devuelve un mensaje de error
