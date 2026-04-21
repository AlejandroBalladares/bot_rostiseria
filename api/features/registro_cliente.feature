# language: es

@local
Característica: Registro de un cliente

  Escenario: US1-api-01 Registro exitoso
    Dado que el cliente con id de telegram "11" no esta registrado
    Cuando hago post /clientes con nombre "Pepe", direccion "calle falsa 123", telefono "1133223322" y id de telegram "1"
    Entonces el cliente se registra con exito

  Escenario: US1-api-02 Registro fallido por usuario existente
    Dado que el cliente con id de telegram "12" esta registrado
    Cuando hago post /clientes con nombre "Pepe", direccion "calle falsa 123", telefono "1133223322" y id de telegram "12"
    Entonces veo un mensaje de registracion fallida

  Escenario: US1-api-03 Registro fallido por registro sin parametros
    Dado que el cliente con id de telegram "13" no esta registrado
    Cuando hago post /clientes sin ningun parametro
    Entonces veo un mensaje de registracion fallida por falta de parametros

  Escenario: US1-api-04 Registro fallido por falta de parametros
    Dado que el cliente con id de telegram "14" no esta registrado
    Cuando hago post /clientes solamente con el parametro "Pepe"
    Entonces veo un mensaje de registracion fallida por falta de parametros
