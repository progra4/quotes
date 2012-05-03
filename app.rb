require 'rack'
require './controllers'

class WebApp
  
  include Controllers

  def call(env)

    request = Rack::Request.new(env)
    controller = QuotesController.new
    
    status, body = controller.dispatch(request)

    [
     status,
     #los valores de los headers *deben* ser String
     {'Content-Type' => 'text/plain', 'Content-Length' => body.size.to_s},
     [body]
    ]
  end
end
