# language: es

Característica: Cancelar pedido

  Escenario: US19-01 Como cliente quiero cancelar un pedido en estado recibido
    Dado que existe un pedido con id 1 en estado 'RECIBIDO'
    Cuando envio /cancelar 1
    Entonces veo un mensaje de que el pedido fue cancelado

  Escenario: US19-02 Como cliente quiero cancelar un pedido en estado preparación
    Dado que existe un pedido con id 1 en estado 'EN_PREPARACION'
    Cuando envio /cancelar 1
    Entonces veo un mensaje de que el pedido fue cancelado

  Escenario: US25-01 Como cliente quiero cancelar un pedido en estado en espera
    Dado que existe un pedido con id 1 en estado 'EN_ESPERA'
    Cuando envio /cancelar 1
    Entonces veo un mensaje de error

  Escenario: US25-02 Como cliente quiero cancelar un pedido en estado en camino
    Dado que existe un pedido con id 1 en estado 'EN_CAMINO'
    Cuando envio /cancelar 1
    Entonces veo un mensaje de error

  Escenario: US25-03 Como cliente quiero cancelar un pedido en estado entregado
    Dado que existe un pedido con id 1 en estado 'ENTREGADO'
    Cuando envio /cancelar 1
    Entonces veo un mensaje de error
