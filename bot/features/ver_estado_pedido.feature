# language: es

Característica: Ver estado pedido

  Antecedentes:
    Dado estoy logueado como el usuario '@pepe' en Telegram

  Escenario: US6-01 Ver estado pedido recibido
    Dado que existe un pedido con id '1' en estado 'RECIBIDO'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje del estado 'RECIBIDO'

  Escenario: US6-02 Ver estado pedido en preparacion
    Dado que existe un pedido con id '1' en estado 'EN_PREPARACION'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje del estado 'EN_PREPARACION'

  Escenario: US6-03 Ver estado pedido en camino
    Dado que existe un pedido con id '1' en estado 'EN_ESPERA'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje del estado 'EN_ESPERA'

  Escenario: US6-04 Ver estado pedido en camino
    Dado que existe un pedido con id '1' en estado 'EN_CAMINO'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje del estado 'EN_CAMINO'

  Escenario: US6-05 Ver estado pedido entregado
    Dado que existe un pedido con id '1' en estado 'ENTREGADO'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje del estado 'ENTREGADO'

  Escenario: US16-01 Ver estado pedido inexistente
    Dado que no existe un pedido con id '1'
    Cuando envio '/pedido 1'
    Entonces veo un mensaje de error

  Escenario: US16-02 Ver estado pedido sin parametro
    Cuando envio '/pedido'
    Entonces veo un mensaje de error