Dado('que existe un repartidor sin pedidos asignados') do
  step 'hay repartidores disponibles'
end

Cuando('finaliza la preparación de un pedido individual') do
  finalizar_pedido(1)
end

Entonces('el pedido puede ser asignado al repartidor') do
  @response = @response_pedido
  step 'se le asigna el pedido al repartidor'
end

Dado('que existe un repartidor con {int} pedidos individuales asignados') do |cantidad_pedidos|
  step 'que solo existe un repartidor sin pedido asignado'
  (1..cantidad_pedidos).each do |_|
    step 'un pedido termina su preparación'
  end
end

Entonces('el pedido queda en espera') do
  step "el pedido tendrá estado 'EN_ESPERA'"
end

Cuando('finaliza la preparación de un pedido pareja') do
  finalizar_pedido(2)
end

Dado('que existe un repartidor con {int} pedido individual y {int} pedido de pareja') do |pedidos_individuales, pedidos_parejas|
  # Pedidos individuales
  step "que existe un repartidor con #{pedidos_individuales} pedidos individuales asignados"

  # Pedidos pareja
  request = { id_menu: 2 }.to_json
  (1..pedidos_parejas).each do |_|
    @response = Faraday.post(pedir_pedido_url, request, header)
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
  end
end

Cuando('finaliza la preparación de un pedido familiar') do
  finalizar_pedido(3)
end

Dado('que existe un repartidor con {int} familiar asignado') do |pedidos_familiares|
  request = { id_menu: 3 }.to_json
  (1..pedidos_familiares).each do |_|
    @response = Faraday.post(pedir_pedido_url, request, header)
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
  end
end

def finalizar_pedido(id_pedido)
  request = { id_menu: id_pedido }.to_json
  @response = Faraday.post(pedir_pedido_url, request, header)

  @response_pedido = @response

  step 'se pasa al siguiente estado'
  step 'se pasa al siguiente estado'
end
