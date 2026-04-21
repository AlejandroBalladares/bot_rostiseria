Dado('que el cliente con id de telegram {string} no esta registrado') do |_|
  # No hacer nada
end

Cuando('hago post \/clientes con nombre {string}, direccion {string}, telefono {string} y id de telegram {string}') do |nombre, direccion, telefono, id_telegram|
  @request = {nombre: nombre, direccion: direccion, telefono: telefono, id_telegram: id_telegram}.to_json
  @response = Faraday.post(crear_cliente_url, @request, header)
end

Entonces('el cliente se registra con exito') do
  expect(@response.status).to eq(201)
end

Dado('que el cliente con id de telegram {string} esta registrado') do |id_telegram|
  @request = {nombre: 'Pepe', direccion: 'Calle Falsa 123', telefono: '312321312', id_telegram: id_telegram}.to_json
  @response = Faraday.post(crear_cliente_url, @request, header)
end

Entonces('veo un mensaje de registracion fallida') do
  expect(@response.status).to eq(409)
end

Cuando('hago post \/clientes sin ningun parametro') do
  @request = {id_telegram: 534_534}.to_json
  @response = Faraday.post(crear_cliente_url, @request, header)
end

Entonces('veo un mensaje de registracion fallida por falta de parametros') do
  expect(@response.status).to eq(400)
end

Cuando('hago post \/clientes solamente con el parametro {string}') do |nombre|
  @request = {nombre: nombre, id_telegram: 123_412_314}.to_json
  @response = Faraday.post(crear_cliente_url, @request, header)
end
