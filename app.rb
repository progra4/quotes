require './models'
require 'rack'

class WebApp
  def call(env)

    request = Rack::Request.new(env)
    
    collection_pattern = /\/quotes$/
    member_pattern     = /\/quotes\/([a-z0-9\-]+)/

    status, body = if request.get?
        if request.path =~ collection_pattern
          [200, Models::Quote.all.map(&:as_text).join("\n")]
        elsif request.path =~ member_pattern
          id = request.path.match(member_pattern)[1]
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
