# language: es

Característica: Validación de registración del repartidor

  Escenario: US14-01 Registracion sin campos
    Cuando intento registrar un repatidor sin nombre y sin documento
    Entonces recibo un mensaje de error

  Escenario: US14-02 Registracion con campos faltantes
    Cuando intento registrar un repatidor con nombre 'pepe' y sin documento
    Entonces recibo un mensaje de error
