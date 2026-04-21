# language: es

Característica: Como dueño quiero que los repartidores tengan un volumen de 3 espacios en sus mochilas

  Escenario: US20-api-01 Un repartidor puede llevar 1 pedido individual
    Dado que existe un repartidor sin pedidos asignados
    Cuando finaliza la preparación de un pedido individual
    Entonces el pedido puede ser asignado al repartidor
    
  Escenario: US20-api-02 Un repartidor puede llevar 3 pedidos individuales
    Dado que existe un repartidor con 2 pedidos individuales asignados
    Cuando finaliza la preparación de un pedido individual
    Entonces el pedido puede ser asignado al repartidor

  Escenario: US20-api-03 Un repartidor no puede llevar 4 pedidos individuales
    Dado que existe un repartidor con 3 pedidos individuales asignados
    Cuando finaliza la preparación de un pedido individual
    Entonces el pedido queda en espera

  Escenario: US20-api-04 Un repartidor puede llevar 1 pedido de pareja
    Dado que existe un repartidor sin pedidos asignados
    Cuando finaliza la preparación de un pedido pareja
    Entonces el pedido puede ser asignado al repartidor

  Escenario: US20-api-05 Un repartidor puede llevar como máximo 1 pedido individual y 1 pedido de pareja
    Dado que existe un repartidor con 1 pedido individual y 1 pedido de pareja
    Cuando finaliza la preparación de un pedido individual
    Entonces el pedido queda en espera

  Escenario: US20-api-06 Un repartidor puede llevar 1 pedido familiar
    Dado que existe un repartidor sin pedidos asignados
    Cuando finaliza la preparación de un pedido familiar
    Entonces el pedido puede ser asignado al repartidor

  Escenario: US20-api-07 Un repartidor puede llevar como máximo 1 pedido familiar
    Dado que existe un repartidor con 1 familiar asignado
    Cuando finaliza la preparación de un pedido familiar
    Entonces el pedido queda en espera
