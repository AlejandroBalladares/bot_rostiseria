Dado('que existe un pedido con id {int} en estado {string}') do |_id_pedido, estado|
  step "que existe un pedido en estado '#{estado}'"
end

Cuando('intento cancelar el pedido {int}') do |_id_pedido|
  @id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  @delete_response = Faraday.delete(cancelar_pedido_url(@id_pedido_creado), header)
end

Entonces('me devuelve el id del pedido borrado') do
  expect(JSON.parse(@delete_response.body)['id']).to eq(@id_pedido_creado)
end

Entonces('me devuelve un mensaje de error') do
  expect(@delete_response.status).to eq(400)
end

