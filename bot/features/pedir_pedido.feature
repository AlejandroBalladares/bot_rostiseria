# language: es

Característica: Pedir pedido

  Antecedentes:
    Dado estoy logueado como el usuario @pepe en Telegram

  Escenario: US3-01 Pedido exitoso
    Dado que estoy registrado
    Cuando envio /pedir 1
    Entonces veo un mensaje de pedido exitoso

  Escenario: US10-01 Pedido no existe
    Dado que estoy registrado
    Cuando envio /pedir 99999
    Entonces veo un mensaje de error

  Escenario: US10-02 Pedir sin pasarle un menu a pedir
    Dado que estoy registrado
    Cuando envio /pedir
    Entonces veo un mensaje de error

  Escenario: US13-01 Pedir varios pedidos separados
    Dado que estoy registrado
    Y ya realicé un pedido previamente
    Cuando envio /pedir 1
    Entonces veo un mensaje de pedido exitoso

  Escenario: US15-01 Pedir mas de un menu es invalido
    Dado que estoy registrado
    Cuando envio /pedir 1,2
    Entonces veo un mensaje de error

