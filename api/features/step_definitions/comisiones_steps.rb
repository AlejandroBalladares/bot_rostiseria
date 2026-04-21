Dado('que existe un repartidor con id {string} con {int} pedido {string} calificado con {string}') do |_id_repartidor, _cantidad_pedido, tipo_pedido, calificacion|
  request = { }.to_json
  Faraday.post(reset_url, request,header)

  request_repartidor = {nombre: 'Pepe', documento: 321312}.to_json
  @response_repartidor = Faraday.post(crear_repartidor_url, request_repartidor, header)

  @id_menu = case tipo_pedido
  when 'individual'
    1
  when 'pareja'
    2
  when 'familiar'
    3
  end
  step "hago post \/pedir #{@id_menu}"
  id_pedido = JSON.parse(@response.body)['id_pedido']

  step 'se pasa al siguiente estado' # EN_PREPARACION
  step 'se pasa al siguiente estado' # EN_CAMINO
  step 'se pasa al siguiente estado' # ENTREGADO

  step "intento calificar el pedido #{id_pedido} con valor #{calificacion}"
end

Cuando('consulto las comisiones del repartidor {int}') do |_id_repartidor|
  id_repartidor = JSON.parse(@response_repartidor.body)['id_repartidor']
  @response_comisiones = Faraday.get(comisiones_repartidor_url(id_repartidor), header)
end

Entonces('obtengo el monto equivalente al {int}% del precio de los pedidos entregados') do |porcentaje|
  response_menu = Faraday.get(menu_url, header)
  menu = JSON.parse(response_menu.body).find { |menu| menu['id'] == @id_menu }

  expect(@response_comisiones.status).to eq(200)
  expect(JSON.parse(@response_comisiones.body)['monto']).to eq(menu['precio'] * porcentaje / 100.0)
end

Dado('que existe un repartidor con id {string} con {int} pedidos individuales calificado con {string}, {string} y {string} respectivamente') do |repartidor, cantidad_pedidos, calificacion1, calificacion2, calificacion3|
  request = { }.to_json
  Faraday.post(reset_url, request,header)

  request_repartidor = {nombre: 'Pepe', documento: 321312}.to_json
  @response_repartidor = Faraday.post(crear_repartidor_url, request_repartidor, header)

  calificaciones = [calificacion1, calificacion2, calificacion3]

  @id_menu = 1
  (1..cantidad_pedidos).each_with_index.each do |_, index|
    step "hago post \/pedir #{@id_menu}"
    id_pedido = JSON.parse(@response.body)['id_pedido']

    step 'se pasa al siguiente estado' # EN_PREPARACION
    step 'se pasa al siguiente estado' # EN_CAMINO
    step 'se pasa al siguiente estado' # ENTREGADO

    step "intento calificar el pedido #{id_pedido} con valor #{calificaciones[index]}"
  end
end

Entonces('obtengo el monto equivalente a la suma del porcentaje correspondiente a la calificación de cada pedido') do
  response_menu = Faraday.get(menu_url, header)
  menu = JSON.parse(response_menu.body).find { |menu| menu['id'] == @id_menu }

  expect(@response_comisiones.status).to eq(200)
  expect(JSON.parse(@response_comisiones.body)['monto']).to eq(menu['precio'] * 0.05 + menu['precio'] * 0.03 + menu['precio'] * 0.07)
end

Dado('que llovio el dia de la entrega') do
  Faraday.put(clima_api_mock_url, { habilitar: true, lluvia: true }.to_json, header)
end

Dado('que existe un repartidor con id {string} con {int} pedido individual calificado con {string} entregado lloviendo') do |_id_repartidor, _cant_pedidos, calificacion|
  Faraday.put(clima_api_mock_url, { habilitar: true, lluvia: true }.to_json, header)

  request = { }.to_json
  Faraday.post(reset_url, request,header)

  request_repartidor = {nombre: 'Pepe', documento: 321312}.to_json
  @response_repartidor = Faraday.post(crear_repartidor_url, request_repartidor, header)

  @id_menu = 1
  step "hago post \/pedir #{@id_menu}"
  id_pedido = JSON.parse(@response.body)['id_pedido']

  step 'se pasa al siguiente estado' # EN_PREPARACION
  step 'se pasa al siguiente estado' # EN_CAMINO
  step 'se pasa al siguiente estado' # ENTREGADO

  step "intento calificar el pedido #{id_pedido} con valor #{calificacion}"
end

Dado('que existe un pedido individual calificado con {string} entregado sin llover') do |calificacion|
  Faraday.put(clima_api_mock_url, { habilitar: true, lluvia: "abuelo" }.to_json, header)

  @id_menu = 1
  step "hago post \/pedir #{@id_menu}"
  id_pedido = JSON.parse(@response.body)['id_pedido']

  step 'se pasa al siguiente estado' # EN_PREPARACION
  step 'se pasa al siguiente estado' # EN_CAMINO
  step 'se pasa al siguiente estado' # ENTREGADO

  step "intento calificar el pedido #{id_pedido} con valor #{calificacion}"
end

Entonces('obtengo el monto equivalente al {int}% del precio en el primer pedido y {int}% del precio en el segundo pedido') do |_porcentaje1, _porcentaje2|
  response_menu = Faraday.get(menu_url, header)
  menu = JSON.parse(response_menu.body).find { |menu| menu['id'] == @id_menu }

  expect(@response_comisiones.status).to eq(200)
  expect(JSON.parse(@response_comisiones.body)['monto']).to eq((menu['precio'] * 0.03) + (menu['precio'] * 0.08))
end
