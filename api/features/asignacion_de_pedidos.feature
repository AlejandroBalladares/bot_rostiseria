# language: es

@local
Característica: Asignación de Pedidos

  Escenario: US8-01 Asignación de un pedido a un repartidor
    Dado que solo existe un repartidor sin pedido asignado
    Cuando un pedido termina su preparación
    Entonces se le asigna el pedido al repartidor

  Escenario: US8-02 No hay repartidores disponibles para asignar
    Dado que no hay repartidores disponibles
    Cuando un pedido termina su preparación
    Entonces no se le asigna el pedido a ningun repartidor
