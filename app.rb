class WebApp
  def call(env)
    lang = env['HTTP_ACCEPT_LANGUAGE'] || 'en'
    path = env['PATH_INFO']

    body = if lang == 'en'
             "you just asked for #{path}, \n with the env #{env.to_s}"
           else
             "acabas de pedir #{path}, \n con el entorno #{env.to_s}"
           end

    [201, {'Content-Type' => "text/plain"}, [body]]
  end
end
