require 'erb'

module Views
  class View
    def initialize(template, layout = nil)
      #must be an instance of View that expects a binding with `body 
      @layout = layout
      @template = ERB.new(template)
    end

    def render(with_binding)
      #this adds body to the top-level binding
      body = @template.result(with_binding)
      if @layout
        @layout.render(binding) 
      else
        body
      end
    end

    def self.define(opts = {}, &builder)
      layout = opts[:in]
      template = builder.call
      View.new(template, layout)
    end
  end

  BASE = View.define do
    #another way of defining
    <<-ERB
       <!doctype>
       <html>
          <head>
              <meta charset="utf-8" />
              <title>Quotes</title>
          </head>
          <body>
              <%= body %>
          </body>
       </html>
    ERB
  end

  INDEX = View.define(in: BASE) do
    <<-ERB
      <h1>Quotes: </h1>
      <ul>
        <% quotes.each do |quote| %>
          <li>
            <blockquote>
              <p><%= quote.content %></p>
              <footer><cite><%= quote.author %></cite></footer>
            </blockquote>
          </li>
        <% end %>
      </ul>
    ERB
  end
end
