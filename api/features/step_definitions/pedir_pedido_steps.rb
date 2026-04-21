Dado('ya realizó un pedido previamente') do
  pending # Write code here that turns the phrase above into concrete actions
end

Cuando('hago post \/pedir {int}') do |id_menu|
  @request = {id_menu: id_menu}.to_json
  @response = Faraday.post(pedir_pedido_url, @request, header)
end

Cuando('hago post \/pedir') do
  @request = '{"id_menu":}'
  @response = Faraday.post(pedir_pedido_url, @request, header)
end

Cuando('hago post \/pedir {string}') do |multiples_pedidos|
  @request = {id_menu: multiples_pedidos}.to_json
  @response = Faraday.post(pedir_pedido_url, @request, header)
end

Entonces('el pedido se crea exitosamente y se devuelve el ID del pedido') do
  expect(@response.status).to eq(201)
  expect(@response.body['id_pedido']).to_not be_nil
end

Entonces('veo un mensaje de error de pedido fallido') do
  expect(@response.status).to eq(400)
end

Entonces('veo un mensaje de error de pedido no encontrado') do
  expect(@response.status).to eq(404)
end
