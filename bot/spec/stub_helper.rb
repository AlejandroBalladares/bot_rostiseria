def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def web_api_stub_post(status, request_body, endpoint = 'clientes', response_body = '')
  stub_request(:post, "#{ENV['API_URL']}/#{endpoint}")
    .with(body: request_body)
    .to_return(status: status, body: response_body, headers: { 'Content-Type' => 'application/json' })
end

def web_api_stub_get(status, endpoint = 'clientes', response_body = '')
  stub_request(:get, "#{ENV['API_URL']}/#{endpoint}")
    .to_return(status: status, body: response_body, headers: { 'Content-Type' => 'application/json' })
end

def web_api_stub_delete(status, endpoint, response_body)
  stub_request(:delete, "#{ENV['API_URL']}/#{endpoint}")
    .to_return(status: status, body: response_body, headers: { 'Content-Type' => 'application/json' })
end
