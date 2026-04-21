# language: es

Característica: Consulta del menu

  Antecedentes:
    Dado estoy logueado como el usuario @pepe en Telegram

  Escenario: US2-01 Consulta del menu exitosa
    Dado que estoy registrado
    Cuando envio /menu
    Entonces veo un mensaje con el listado con las opciones del menu
    Y un mensaje de como hacer el pedido

  Escenario: US2-02 Consulta del menu sin registrarse
    Dado que no estoy registrado
    Cuando envio /menu
    Entonces veo un mensaje de como registrarme
