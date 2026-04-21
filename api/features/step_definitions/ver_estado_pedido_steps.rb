Dado('que existe un pedido con id {string} en estado {string}') do |_id, estado|
  request = { id_menu: 1 }.to_json
  @response = Faraday.post(pedir_pedido_url, request, header)

  n = case estado
  when 'EN_PREPARACION'
    1
  when 'EN_CAMINO'
    step 'hay repartidores disponibles'
    2
  when 'EN_ESPERA'
    step 'no hay repartidores disponibles'
    2
  when 'ENTREGADO'
    3
  else
    0
  end

  (1..n).each do |_|
    step 'se pasa al siguiente estado'
  end
end

Cuando('hago get de \/pedidos\/{int}') do |id_pedido|
  id_pedido_creado = @response.nil? ? id_pedido : JSON.parse(@response.body)['id_pedido']
  @response = Faraday.get(estado_pedido_url(id_pedido_creado), header)
end

Entonces('veo un mensaje del estado {string}') do |estado|
  expect(JSON.parse(@response.body)['estado']).to eq(estado)
end

Dado('que no existen pedidos') do
  request = { }.to_json
  Faraday.post(reset_url, request,header)
end

Entonces('veo un mensaje de error') do
  expect(@response.status).to eq(404)
end

