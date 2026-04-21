Dado('que solo existe un repartidor sin pedido asignado') do
  step 'que no hay repartidores disponibles'

  request = {nombre: 'Pepe', documento: 12345678}.to_json
  @response_repartidor = Faraday.post(crear_repartidor_url, request, header)
end

Cuando('un pedido termina su preparación') do
  request = { id_menu: 1 }.to_json
  @response = Faraday.post(pedir_pedido_url, request, header)
  (1..2).each do |_|
    step 'se pasa al siguiente estado'
  end
end

Entonces('se le asigna el pedido al repartidor') do
  id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  response = Faraday.get(estado_pedido_url(id_pedido_creado), header)
  id_repartidor = JSON.parse(@response_repartidor.body)['id_repartidor']
  expect(JSON.parse(response.body)['id_repartidor']).to eq(id_repartidor)
end

Dado('que no hay repartidores disponibles') do
  Persistence::Repositories::RepartidorRepository.new.delete_all
end

Entonces('no se le asigna el pedido a ningun repartidor') do
  id_pedido_creado = JSON.parse(@response.body)['id_pedido']
  response = Faraday.get(estado_pedido_url(id_pedido_creado), header)
  expect(JSON.parse(response.body)['id_repartidor']).to be_nil
end
