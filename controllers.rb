require './models'
require './views'

module Controllers
  class NotFoundException < Exception; end

  class Controller
    
    attr_accessor :request

    def initialize(request)
      @request = request
    end

    def route
      collection_pattern = /\/#{resource_name}$/
      member_pattern     = /\/#{resource_name}\/([a-z0-9\-]+)/

      #non-restful actions
      if request.path == "/#{resource_name}/new"
        return new
      end

      #REST hacks:
      #
      #Since browsers can only do GET and POST, we use this hack to
      #simulate PUT and DELETE
      #rack already does this, so...
      if request.params["_method"]
        request.env["REQUEST_METHOD"] = request.params["_method"]
      end

      #collection actions
      if request.path =~ collection_pattern
        if request.get?
          return index
        elsif request.post?
          return create
        else
          return [405, ""]
        end
      end
      
      #member actions
      if request.path =~ member_pattern
        request.params["id"] = request.path.match(member_pattern)[1]
        if request.get?
          # show <=> read
          return show
        elsif request.put?
          return update
        elsif request.delete?
          return destroy
        else
          return [405, ""]
        end
      end


      #a not implemented path was requested
      return [501, ""]
    end


    def dispatch
      begin
        status, body = route
        if status == 301
          [status, {'Location' => body}, ""]
        else
          [status, {}, body]
        end
      rescue NotFoundException
        [404,{}, ""]
      rescue Exception => e
        [500,{}, e.to_s]
      end
    end
  end


  class QuotesController < Controller
    include Models
    include Views

    def resource_name
      "quotes"
    end

    def index
      quotes = unless request.params["author"]
        Quote.all
      else
        Quote.where_include author: request.params["author"]
      end
      [200, INDEX.render(binding)]
    end

    def new
      [200, NEW.render]
    end

    def show
      quote = Quote.find(request.params["id"])
      if quote
        [200, SHOW.render(binding)]
      else
        raise NotFoundException
      end
    end

    def create
      quote = Quote.create(
        content: request.params["content"],
        author:  request.params["author"]
      )

      #redirect to the quote
      [301, "/quotes/#{quote.id}"]
    end

    def destroy
      quote = Quote.find(request.params["id"])
      quote.destroy
      if quote
        [301, "/quotes"]
      else
        raise NotFoundException
      end
    end
  end
end
