Cuando('intento registrar un repatidor con nombre {string} y documento {string}') do |nombre, documento|
  @request = {nombre: nombre, documento: documento}.to_json
  @response = Faraday.post(crear_repartidor_url, @request, header)
end

Entonces('recibo el numero de identificación del repartidor creado') do
  body = JSON.parse(@response.body)
  expect(body['id_repartidor']).to_not be_nil
end
