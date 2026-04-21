WebTemplate::App.controllers :clientes, :provides => [:json] do
  post :create, :map => '/clientes' do
    begin
      cliente = Cliente.new(cliente_params[:nombre], cliente_params[:direccion], cliente_params[:telefono], cliente_params[:id_telegram])
      cliente_repo.save(cliente)
      status 201
    rescue ClienteInvalidoError => e
      status 400
      {error: e.message}.to_json
    rescue ClienteYaRegistradoError => e
      status 409
      {error: e.message}.to_json
    end
  end
end
