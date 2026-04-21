Cuando('intento calificar el pedido {int} con valor {int}') do |_id_pedido, puntuacion|
  id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  request = {puntuacion: puntuacion}.to_json
  @response = Faraday.post(calificar_pedido_url(id_pedido_creado), request, header)
end

Entonces('veo un mensaje de que el pedido fue calificado con {int}') do |puntuacion|
  expect(@response.status).to eq(201)
  expect(JSON.parse(@response.body)['puntuacion']).to eq(puntuacion)
end

Dado('que existe un pedido con id {string} y su estado no es {string}') do |_id_pedido, _estado|
  step "que existe un pedido en estado 'EN_PREPARACION'"
end

Entonces('veo un mensaje de error de calificacion en estado invalido') do
  expect(@response.status).to eq(400)
  expect(JSON.parse(@response.body)['codigo_error']).to eq('CALIFICACION_ESTADO_INVALIDO')
end

Entonces('veo un mensaje de error de calificacion con puntaje invalido') do
  expect(@response.status).to eq(400)
  expect(JSON.parse(@response.body)['codigo_error']).to eq('CALIFICACION_PUNTAJE_INVALIDO')
end

Dado('que existe un pedido con id {string} que le pertenece al cliente con id {string} y su estado es {string}') do |_id_pedido, _id_cliente, estado|
  @id_telegram = 123432
  request = {nombre: 'Pepe', direccion: 'direccion', telefono: 431243, id_telegram: @id_telegram}.to_json
  @response = Faraday.post(crear_cliente_url, request, header)

  step "que existe un pedido en estado '#{estado}'"
  @id_pedido_creado = JSON.parse(@response.body)['id_pedido']
end

Cuando('el cliente con id {string} intenta calificar al pedido') do |_id_cliente|
  id_telegram_erroneo = 432423
  request = { puntuacion: 5, id_telegram: id_telegram_erroneo }.to_json
  @response = Faraday.post(calificar_pedido_url(@id_pedido_creado), request, header)
end

Entonces('veo un mensaje de error de calificacion usuario invalido') do
  expect(@response.status).to eq(409)
end
