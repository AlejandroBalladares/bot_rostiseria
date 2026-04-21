# language: es

@local
Característica: Calificación de pedidos

  Escenario: US7-01 Calificar correctamente un pedido
    Dado que existe un pedido con id '1' en estado 'ENTREGADO'
    Cuando intento calificar el pedido 1 con valor 2
    Entonces veo un mensaje de que el pedido fue calificado con 2

  Escenario: US23-01 El valor maximo para calificar es 5
    Dado que existe un pedido con id '1' en estado 'ENTREGADO'
    Cuando intento calificar el pedido 1 con valor 6
    Entonces veo un mensaje de error de calificacion con puntaje invalido

  Escenario: US23-02 El valor minimo para calificar es 1
    Dado que existe un pedido con id '1' en estado 'ENTREGADO'
    Cuando intento calificar el pedido 1 con valor 0
    Entonces veo un mensaje de error de calificacion con puntaje invalido

  Escenario: US24-01 Solo se puede calificar un pedido entregado
    Dado que existe un pedido con id '1' y su estado no es 'ENTREGADO'
    Cuando intento calificar el pedido 1 con valor 2
    Entonces veo un mensaje de error de calificacion en estado invalido

  Escenario: US26-01 Solo se puede calificar un pedido realizado por uno mismo
    Dado que existe un pedido con id '1' que le pertenece al cliente con id '10' y su estado es 'ENTREGADO'
    Cuando el cliente con id '11' intenta calificar al pedido
    Entonces veo un mensaje de error de calificacion usuario invalido

  @siguiente_iteracion @wip
  Escenario: US7-03 Solo se puede calificar un pedido existente
    Dado que no existe un pedido con id '1'
    Cuando hago post /pedidos/1/calificaciones con valor 2
    Entonces veo un mensaje de calificacion fallida

