require 'erb'

module Views
  class View
    def initialize(template, layout = nil)
      #must be an instance of View that expects a binding with `body 
      @layout = layout
      @template = ERB.new(template)
    end

    def render(with_binding = nil)
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
      <a href="/quotes/new">New Quote</a>
    ERB
  end

  NEW = View.define(in: BASE) do
    <<-ERB
      <form action="/quotes" method = "post">
        <p>
         <label for="c">Content</label>
         <textarea id="c" name="content"></textarea>
        </p>
        <p>
         <label for="c">Author</label>
         <input type="text" id="a" name="author"/>
        </p>

         <input type="submit" value="Create" />
      </form>
    ERB
  end
end
