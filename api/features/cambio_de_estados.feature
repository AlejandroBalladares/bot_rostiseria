# language: es

Característica: Cambio de estados

  Escenario: US5-01 Creacion de un pedido
    Cuando se crea un nuevo pedido
    Entonces el pedido tendrá estado 'RECIBIDO'

  Escenario: US5-02 Cambio de estado a en preparacion
    Dado que existe un pedido en estado 'RECIBIDO'
    Cuando se pasa al siguiente estado
    Entonces el pedido tendrá estado 'EN_PREPARACION'

  @local
  Escenario: US12-01 Cambio de estado a en espera
    Dado que existe un pedido en estado 'EN_PREPARACION'
    Cuando no hay repartidores disponibles
    Y se pasa al siguiente estado
    Entonces el pedido tendrá estado 'EN_ESPERA'

  @local
  Escenario: US12-02 Cambio de estado a en camino
    Dado que existe un pedido en estado 'EN_PREPARACION'
    Cuando hay repartidores disponibles
    Y se pasa al siguiente estado
    Entonces el pedido tendrá estado 'EN_CAMINO'

  @local
  Escenario: US18-01 Cambio de estado a entregado
    Dado que existe un pedido en estado 'EN_CAMINO'
    Cuando se pasa al siguiente estado
    Entonces el pedido tendrá estado 'ENTREGADO'
