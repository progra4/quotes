module Views
require 'erb'

        class View
                def initialize(template, layout = :layout)#simbolo, view
                @layout = View.new(:layout) unless template == :layout
                @template = template = ERB.new(File.read("#{Dir.pwd}/views/#{template}.html.erb"))
                end

                def render(other_binding)
                        body = @template.result(other_binding)
                        if @layout
                                @layout.render(binding)
                        else
                                body
                        end
                end
        end
end
