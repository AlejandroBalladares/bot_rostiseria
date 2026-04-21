WebTemplate::App.controllers :pedidos, :provides => [:json] do
  post :create, :map => '/pedidos' do
    menu = menu_repo.find(pedidos_params[:id_menu])
    esta_lloviendo = clima_api.esta_lloviendo?
    cliente = cliente_repo.find_by_id_telegram(pedidos_params[:id_telegram])
    pedido = Pedido.new(menu, nil, EstadoPedido::RECIBIDO, nil, nil, esta_lloviendo, cliente)
    pedidos_repo.save(pedido)
    status 201
    { 'id_pedido': pedido.id }.to_json
  end

  get :show, :map => '/pedidos', :with => :id do
    id_pedido = params[:id]

    begin
      pedido = pedidos_repo.find(id_pedido)
      pedido_to_json pedido
    rescue ObjectNotFound => e
      status 404
      return { 'error': e.message }.to_json
    end
  end

  put :update, :map => '/pedidos/:id_pedido/estados' do
    pedido = pedidos_repo.find(params[:id_pedido])
    asignador_pedidos = AsignadorPedidos.new(repartidor_repo)
    pedido.siguiente_estado(asignador_pedidos)
    pedidos_repo.save(pedido)
    pedido_to_json pedido
  end

  post :create, :map => '/pedidos/:id_pedido/calificaciones' do
    pedido = pedidos_repo.find(params[:id_pedido])

    if !calificacion_params[:id_telegram].nil? && !pedido.pertenece_a?(calificacion_params[:id_telegram])
      status 409
      return
    end

    if pedido.es_calificable?
      begin
      calificacion = CalificadorPedidos.new(calificacion_repo).calificar(pedido.id, calificacion_params[:puntuacion])
      status 201
      calificacion_to_json calificacion

      rescue CalificacionPuntajeInvalidoError
        status 400
        return calificacion_puntaje_invalido_error_to_json
      end
    else
      status 400
      calificacion_estado_invalido_error_to_json
    end
  end

  delete :delete, :map => '/pedidos/:id_pedido/cancelaciones' do
    pedido = pedidos_repo.find(params[:id_pedido])

    if pedido.es_cancelable?
      pedidos_repo.delete(pedido)

      status 200
      pedido_to_json pedido
    else
      status 400
    end
  end
end
