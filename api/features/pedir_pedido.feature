# language: es

@local
Característica: Pedir pedido

  Escenario: US3-api-01 Pedido exitoso
    Dado que el cliente con id de telegram "31" esta registrado
    Cuando hago post /pedir 1
    Entonces el pedido se crea exitosamente y se devuelve el ID del pedido

  @wip
  Escenario: US10-api-01 Pedido no existe
    Dado que el cliente con id de telegram "32" esta registrado
    Cuando hago post /pedir 99999
    Entonces veo un mensaje de error de pedido no encontrado

  @wip
  Escenario: US10-api-02 Pedir sin pasarle un menu a pedir
    Dado que el cliente con id de telegram "3" esta registrado
    Cuando hago post /pedir
    Entonces veo un mensaje de error de pedido fallido

  @wip
  Escenario: US13-api-01 Pedir varios pedidos separados
    Dado que el cliente con id de telegram "34" esta registrado
    Y ya realizó un pedido previamente
    Cuando hago post /pedir 1
    Entonces el pedido se crea exitosamente y se devuelve el ID del pedido

  @wip
  Escenario: US15-01 Pedir mas de un menu es invalido
    Dado que el cliente con id de telegram "35" esta registrado
    Cuando hago post /pedir "1,2"
    Entonces veo un mensaje de error de pedido fallido
