require 'erb'

module Views
  class View
    def initialize(template_or_name, layout = nil)
      #must be an instance of View that expects a binding with `body 
      @layout = layout
      @template = if template_or_name.is_a?(String)
                    ERB.new(template_or_name)
                  else
                    ERB.new(File.read("#{Dir.pwd}/views/#{template_or_name}.html.erb"))
                  end
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

    def self.create(template_name, layout = :layout)
      View.new(template_name, View.new(:layout))
    end
  end
end
