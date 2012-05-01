class WebApp
  def call(env)
    [201, {'Content-Type' => "text/plain"}, ['Hola Rackup']]
  end
end
