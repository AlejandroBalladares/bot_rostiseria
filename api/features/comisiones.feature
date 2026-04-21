# language: es

@local
Característica: Comisiones

  Escenario: US9-01 Consultar comisión de un repartidor con calificacion media
    Dado que existe un repartidor con id '1' con 1 pedido 'individual' calificado con '3'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 5% del precio de los pedidos entregados

  Escenario: US9-02 Consultar comisión de un repartidor con calificacion minima
    Dado que existe un repartidor con id '1' con 1 pedido 'individual' calificado con '1'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 3% del precio de los pedidos entregados

  Escenario: US9-03 Consultar comisión de un repartidor con calificacion maxima
    Dado que existe un repartidor con id '1' con 1 pedido 'individual' calificado con '5'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 7% del precio de los pedidos entregados

  Escenario: US9-04 Consultar comisión de un repartidor con varios pedidos
    Dado que existe un repartidor con id '1' con 3 pedidos individuales calificado con '5', '3' y '1' respectivamente
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente a la suma del porcentaje correspondiente a la calificación de cada pedido

  Escenario: US9-05 Consultar comisión de un repartidor con calificaciones media y pedido pareja
    Dado que existe un repartidor con id '1' con 1 pedido 'pareja' calificado con '3'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 5% del precio de los pedidos entregados

  Escenario: US9-06 Consultar comisión de un repartidor con calificaciones media y pedido familiar
    Dado que existe un repartidor con id '1' con 1 pedido 'familiar' calificado con '3'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 5% del precio de los pedidos entregados

  Escenario: US22-01 Consultar comisión de un repartidor con calificacion media y lluvia suma 1%
    Dado que llovio el dia de la entrega
    Y que existe un repartidor con id '1' con 1 pedido 'individual' calificado con '3'
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 6% del precio de los pedidos entregados

  Escenario: US22-02 Consultar comisión de un repartidor con 1 pedido con lluvia y 1 pedido sin lluvia
    Dado que existe un repartidor con id '1' con 1 pedido individual calificado con '5' entregado lloviendo
    Y que existe un pedido individual calificado con '1' entregado sin llover
    Cuando consulto las comisiones del repartidor 1
    Entonces obtengo el monto equivalente al 8% del precio en el primer pedido y 3% del precio en el segundo pedido
