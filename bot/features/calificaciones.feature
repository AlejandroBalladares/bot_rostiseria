# language: es

Característica: Un cliente puede calificar pedidos

  Antecedentes:
    Dado estoy logueado como el usuario '@pepe' en Telegram

  Escenario: US7-01 Calificar un pedido
    Dado que pedi un pedido con id '1' y su estado es 'ENTREGADO'
    Cuando envio '/calificar 1,2'
    Entonces veo un mensaje de que el pedido fue calificado con éxito

  Escenario: US23-01 El valor maximo para calificar es 5
    Dado que pedi un pedido con id '2' y su estado es 'ENTREGADO'
    Cuando envio '/calificar 2,9'
    Entonces veo un mensaje de calificacion fallida

  Escenario: US23-02 El valor minimo para calificar es 1
    Dado que pedi un pedido con id '2' y su estado es 'ENTREGADO'
    Cuando envio '/calificar 2,0'
    Entonces veo un mensaje de calificacion fallida

  Escenario: US24-01 Solo se puede calificar un pedido entregado
    Dado que pedi un pedido con id '3' y no está en estado 'ENTREGADO'
    Cuando envio '/calificar 3,1'
    Entonces veo un mensaje de calificacion fallida
    
  Escenario: US26-01 Solo se puede calificar un pedido realizado por uno mismo
    Dado que el pedido con id 8 le pertenece al usuario '@Montoto'
    Cuando envio '/calificar 8,5'
    Entonces veo un mensaje de calificacion fallida

  @siguiente_iteracion
  Escenario: US7-03 Calificar un pedido no existente
    Dado que no existe el pedido con id 99
    Cuando envio '/calificar 99,2'
    Entonces veo un mensaje de calificacion fallida
