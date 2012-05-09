require 'rack'
require './controllers'

class WebApp
  
  include Controllers

  def call(env)

    request = Rack::Request.new(env)
    controller = QuotesController.new(request)
    
    status, body = controller.dispatch

    [
     status,
     #los valores de los headers *deben* ser String
     {'Content-Type' => 'text/html', 'Content-Length' => body.size.to_s},
     [body]
    ]
  end
end
