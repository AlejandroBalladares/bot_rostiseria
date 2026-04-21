Dado('que existe un repartidor con id {int} con {int} pedidos individuales en su mochila') do |id_repartidor, cant_pedidos_individuales|
  step 'que existe un repartidor sin pedidos asignados'

  if id_repartidor == 1
    @id_repartidor_1 = JSON.parse(@response_repartidor.body)['id_repartidor']
  else
    @id_repartidor_2 = JSON.parse(@response_repartidor.body)['id_repartidor']
  end

  request = { id_menu: 1 }.to_json
  (1..cant_pedidos_individuales).each do |_|
    @response = Faraday.post(pedir_pedido_url, request, header)
    step 'se pasa al siguiente estado' # En preparacion
    step 'se pasa al siguiente estado' # En camino
    step 'se pasa al siguiente estado' # Entregado
  end

  step 'finaliza la preparación de un pedido individual'

  if id_repartidor == 1
    step 'finaliza la preparación de un pedido individual'
    @pedido_individual_extre = @response_pedido
  else
    @response = @pedido_individual_extre
    step 'se pasa al siguiente estado'
  end
end

Dado('que existe un repartidor con id {int} sin pedidos') do |_id_repartidor|
  step 'que existe un repartidor sin pedidos asignados'
  @id_repartidor_2 = JSON.parse(@response_repartidor.body)['id_repartidor']
end

Cuando('un pedido de pareja termina su preparación') do
  step 'finaliza la preparación de un pedido pareja'
end

Entonces('se asigna el pedido al repartidor con id {int}') do |id_repartidor|
  id_pedido_creado = JSON.parse(@response_pedido.body)['id_pedido']
  response = Faraday.get(estado_pedido_url(id_pedido_creado), header)
  case id_repartidor
  when 1
    expect(JSON.parse(response.body)['id_repartidor']).to eq(@id_repartidor_1)
  else
    expect(JSON.parse(response.body)['id_repartidor']).to eq(@id_repartidor_2)
  end
end

Dado('que existe un repartidor con id {int} con un pedido individual y {int} pedidos realizados') do |id_repartidor, cant_pedidos_realizados|
  step 'que existe un repartidor sin pedidos asignados'

  if id_repartidor == 1
    @id_repartidor_1 = JSON.parse(@response_repartidor.body)['id_repartidor']
  else
    @id_repartidor_2 = JSON.parse(@response_repartidor.body)['id_repartidor']
  end

  request = { id_menu: 1 }.to_json
  (1..cant_pedidos_realizados).each do |_|
    @response = Faraday.post(pedir_pedido_url, request, header)
    step 'se pasa al siguiente estado' # En preparacion
    step 'se pasa al siguiente estado' # En camino
    step 'se pasa al siguiente estado' # Entregado
  end

  step 'finaliza la preparación de un pedido individual'

  if id_repartidor == 1
    step 'finaliza la preparación de un pedido pareja'
    @pedido_pareja = @response_pedido
  else
    @response = @pedido_pareja
    step 'se pasa al siguiente estado'
  end

end

Cuando('un pedido individual termina su preparación') do
  step 'finaliza la preparación de un pedido individual'
end

Cuando('un pedido familiar termina su preparación') do
  step 'finaliza la preparación de un pedido familiar'
end
