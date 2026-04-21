WebTemplate::App.controllers :repartidores, :provides => [:json] do
  post :create, :map => '/repartidores' do
    repartidor = Repartidor.new(repartidor_params[:nombre], repartidor_params[:documento])
    repartidor = repartidor_repo.save(repartidor)

    status 201
    {id_repartidor: repartidor.id}.to_json
  end

  get :show, :map => '/repartidores/:id_repartidor/comisiones' do
    id_repartidor = params[:id_repartidor]
    repartidor = repartidor_repo.find(id_repartidor)
    pedidos = pedidos_repo.find_by_id_repartidor_entregado(repartidor.id)

    {monto: repartidor.calcular_comisiones(pedidos)}.to_json
  end
end
