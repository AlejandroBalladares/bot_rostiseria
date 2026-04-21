# language: es

@local
Característica: Ver estado pedido

  Escenario: US6-api-01 Ver estado pedido recibido
    Dado que existe un pedido con id '1' en estado 'RECIBIDO'
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje del estado 'RECIBIDO'

  Escenario: US6-api-02 Ver estado pedido en preparacion
    Dado que existe un pedido con id '1' en estado 'EN_PREPARACION'
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje del estado 'EN_PREPARACION'

  Escenario: US6-api-03 Ver estado pedido en espera
    Dado que existe un pedido con id '1' en estado 'EN_ESPERA'
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje del estado 'EN_ESPERA'

  Escenario: US6-api-04 Ver estado pedido en camino
    Dado que existe un pedido con id '1' en estado 'EN_CAMINO'
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje del estado 'EN_CAMINO'

  Escenario: US6-api-05 Ver estado pedido entregado
    Dado que existe un pedido con id '1' en estado 'ENTREGADO'
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje del estado 'ENTREGADO'

  Escenario: US16-api-01 Pedido inexistente devuelve error
    Dado que no existen pedidos
    Cuando hago get de /pedidos/1
    Entonces veo un mensaje de error
