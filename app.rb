require 'rack'
class WebApp
    def call(env)
          [200, {}, ['Hola Mundo']]
           end
end
Rack::Handler::WEBrick.run(WebApp.new, Port: 3000) rescue nil
