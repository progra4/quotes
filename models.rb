require 'securerandom'
module Models
  class Quote
    attr_accessor :author, :content, :language
    attr_reader :id

    def initialize(author, content, language = 'en')
      @id = SecureRandom.uuid
      @author = author
      @content = content
      @language = language
    end

    def as_text
      "
        #{id}.
        #{content}
        --#{author}
      "
    end

    def self.create(hash_or_array)
      if hash_or_array.is_a?(Hash)
        hsh = hash_or_array
        Quote.new(hsh[:author], hsh[:content], hsh[:language])
      elsif hash_or_array.is_a?(Array) && hash_or_array.all?{|e| e.is_a?(Hash)}
        hash_or_array.map{|h|  Quote.create(h)  }
      end
    end
  end

  QUOTES = Quote.create([
      {
        author: "Ralph Waldo Emerson",
        content: "Every sweet has its sour; every evil its good.",
        language: "en"
      },
      {
        author: "Winston Churchill",
        content: "We make a living by what we get, we make a life by what we give",
        language: "en"
      },
      {
        author: "Siddhartha Gautama",
        content: "El dolor es inevitable pero el sufrimiento es opcional.",
        language: "es"
      },
      {
        author: "Walt Whitman",
        content: "Be curious, not judgmental",
        language: "en"
      }
  ])
end
