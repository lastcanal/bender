defmodule Matrix.Client do
  def login!(%Matrix.Config{home_server: home_server, user: user, password: password}) do
    data = %{user: user, password: password, type: "m.login.password"}
    response = HTTPoison.post!("https://#{home_server}/_matrix/client/api/v1/login",  Poison.encode!(data), [], timeout: 10_000)
    Poison.decode!(response.body, as: Matrix.Session)
  end

  def join!(%{ "home_server" => home_server, "access_token" => access_token }, room_name) do
    room_response = HTTPoison.post!("https://#{home_server}/_matrix/client/api/v1/join/#{room_name}?access_token=#{access_token}", "", [], timeout: 10_000)
    Poison.decode!(room_response.body, as: Matrix.Room)
  end

  def events!(%{ "home_server" => home_server, "access_token" => access_token }, from \\ nil) do
    params = [timeout: 30000, access_token: access_token]

    if from do
      params = Dict.put params, :from, from
    end

    response = HTTPoison.get!("https://#{home_server}/_matrix/client/api/v1/events", ["Accept": "application/json"], params: params, recv_timeout: 40000, timeout: 10_000)

    data = Poison.decode!(response.body)
    Matrix.ResponseConstructer.events(data)
  end

  def post!(%{ "home_server" => home_server, "access_token" => access_token }, room = %Matrix.Room{}, message, msg_type \\ "m.text", event_type \\ "m.room.message") do
    data = %{msgtype: msg_type, body: message}

    response = HTTPoison.post!("https://#{home_server}/_matrix/client/api/v1/rooms/#{room.room_id}/send/#{event_type}?access_token=#{access_token}", Poison.encode!(data))

    Poison.decode!(response.body, as: Matrix.EventId)
  end
end
