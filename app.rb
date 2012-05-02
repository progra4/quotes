require './models'
class WebApp
  def call(env)
    method = env["REQUEST_METHOD"]
    path   = env["REQUEST_PATH"]

    collection_pattern = /\/quotes$/
    member_pattern     = /\/quotes\/([a-z0-9\-]+)/

    status, body = case method
      when "GET"
        if path =~ collection_pattern
          [200, Models::Quote.all.map(&:as_text).join("\n")]
        elsif path =~ member_pattern
          id = path.match(member_pattern)[1]
          quote = Models::Quote.find(id)
          if quote
            [200, quote.as_text]
          else
            [404, ""]
          end
        else
          [501, "Not Implemented"]
        end
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
