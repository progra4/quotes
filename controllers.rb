require './models'
module Controllers
  class NotFoundException < Exception; end

  class Controller
    def route(request)
      collection_pattern = /\/#{resource_name}$/
      member_pattern     = /\/#{resource_name}\/([a-z0-9\-]+)/


      puts request.path
      puts collection_pattern, member_pattern
      #collection actions
      if request.path =~ collection_pattern
        if request.get?
          return index(request)
        elsif request.post?
          return create(request)
        else
          return [405, ""]
        end
      end
      
      #member actions
      if request.path =~ member_pattern
        request.params["id"] = request.path.match(member_pattern)[1]
        if request.get?
          # show <=> read
          return show(request)
        elsif request.put?
          return update(request)
        elsif request.delete?
          return destroy(request)
        else
          return [405, ""]
        end
      end

      #a not implemented path was requested
      return [501, ""]
    end


    def dispatch(request)
      begin
        route request
      rescue NotFoundException
        [404, ""]
      rescue
        [500, ""]
      end
    end
  end


  class QuotesController < Controller
    include Models

    def resource_name
      "quotes"
    end

    def index(request)
      [200, Quote.all.map(&:as_text).join("\n")]
    end

    def show(request)
      quote = Quote.find(request.params["id"])
      if quote
        [200, quote.as_text]
      else
        raise NotFoundException
      end
    end
  end
end
