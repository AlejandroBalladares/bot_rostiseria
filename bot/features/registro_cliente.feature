# language: es

Característica: Registro de un cliente

  Escenario: US1-01 Registro exitoso
    Dado estoy logueado como el usuario @pepe en Telegram
    Cuando envio /registrar Pepe,Calle Falsa 123,1133223322
    Entonces veo un mensaje de registracion exitosa

  Escenario: US1-02 Registro fallido por usuario existente
    Dado estoy logueado como el usuario @pepe en Telegram
    Y ya estoy registrado
    Cuando envio /registrar Pepe,Calle Falsa 123,1133223322
    Entonces veo un mensaje de registracion fallida

  Escenario: US1-03 Registro fallido por registro sin parametros
    Dado estoy logueado como el usuario @pepe en Telegram
    Cuando envio /registrar
    Entonces veo un mensaje de como registrarse

  Escenario: US1-04 Registro fallido por falta de parametros
    Dado estoy logueado como el usuario @pepe en Telegram
    Cuando envio /registrar Pepe
    Entonces veo un mensaje de como registrarse

  Escenario: US1-05 Registro fallido por parametros vacios
    Dado estoy logueado como el usuario @pepe en Telegram
    Cuando envio /registrar Pepe,,
    Entonces veo un mensaje de registracion fallida
