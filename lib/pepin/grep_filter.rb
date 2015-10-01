module Pepin
  class GrepFilter
    def pattern(query)
      query.empty? ? nil : Regexp.new(Regexp.quote(query), 'i')
    end

    def select(list, query)
      query.empty? ? list : list.grep(pattern(query))
    end
  end
end
