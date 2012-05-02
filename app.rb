require './models'
class WebApp
  def call(env)
    method = env["REQUEST_METHOD"]
    status, body = case method
      when "GET"
        [200, Models::Quote.all.map(&:as_text).join("\n")]
      else
        [405, ""]
      end

    [
     status,
     #los valores de los headers *deben* ser String
     {'Content-Type' => 'text/plain', 'Content-Length' => body.size.to_s},
     [body]
    ]
  end
end
