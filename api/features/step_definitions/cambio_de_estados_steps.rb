Cuando('se crea un nuevo pedido') do
  @request = { id_menu: 1 }.to_json
  @response = Faraday.post(pedir_pedido_url, @request, header)
end

Entonces('el pedido tendrá estado {string}') do |estado|
  id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  response = Faraday.get(estado_pedido_url(id_pedido_creado), header)
  expect(JSON.parse(response.body)['estado']).to eq(estado)
end

Dado('que existe un pedido en estado {string}') do |estado|
  @request = { id_menu: 1, id_telegram: @id_telegram }.to_json
  @response = Faraday.post(pedir_pedido_url, @request, header)

  case estado
  when 'EN_PREPARACION'
    step 'se pasa al siguiente estado'
  when 'EN_ESPERA'
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
  when 'EN_CAMINO'
    step 'hay repartidores disponibles'
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
  when 'ENTREGADO'
    step 'hay repartidores disponibles'
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
    step 'se pasa al siguiente estado'
  end
end

Cuando('se pasa al siguiente estado') do
  id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  Faraday.put(pasar_estado_pedido_url(id_pedido_creado), header)
end

Cuando('no hay repartidores disponibles') do
  Persistence::Repositories::RepartidorRepository.new.delete_all
end

Cuando('hay repartidores disponibles') do
  request = {nombre: 'Pepe', documento: 12345689}.to_json
  @response_repartidor = Faraday.post(crear_repartidor_url, request, header)
end
