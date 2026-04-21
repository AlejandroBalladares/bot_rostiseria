Cuando('hago get \/menus') do
  @response = Faraday.get(menu_url, header)
end

Entonces('veo el listado con las opciones del menu') do
  expect(@response.status).to eq(200)
  body = JSON.parse(@response.body)
  expect(body[0]['id']).to_not be_nil
  expect(body[0]['nombre']).to_not be_nil
  expect(body[0]['precio']).to_not be_nil
end
