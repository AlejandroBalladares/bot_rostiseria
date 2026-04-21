# language: es

Característica: Asignación de pedidos con lógica

  Escenario: US21-01 Asignacion basada en llenar peso
    Dado que existe un repartidor con id 1 con 2 pedidos individuales en su mochila
    Y que existe un repartidor con id 2 sin pedidos
    Cuando un pedido de pareja termina su preparación
    Entonces se asigna el pedido al repartidor con id 2

  Escenario: US21-02 Asignacion basada en cantidad de pedidos
    Dado que existe un repartidor con id 1 con un pedido individual y 5 pedidos realizados
    Y que existe un repartidor con id 2 con un pedido individual y 2 pedidos realizados
    Cuando un pedido de pareja termina su preparación
    Entonces se asigna el pedido al repartidor con id 2

  Escenario: US21-03 Asignacion priorizando llenar el bolso
    Dado que existe un repartidor con id 1 con 2 pedidos individuales en su mochila
    Y que existe un repartidor con id 2 con 1 pedidos individuales en su mochila
    Cuando un pedido individual termina su preparación
    Entonces se asigna el pedido al repartidor con id 1

  Escenario: US21-04 Asignacion de pedido familiar
    Dado que existe un repartidor con id 1 con 2 pedidos individuales en su mochila
    Y que existe un repartidor con id 2 sin pedidos
    Cuando un pedido familiar termina su preparación
    Entonces se asigna el pedido al repartidor con id 2

