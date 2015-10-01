require 'pepin/version'

module Pepin
  autoload :InteractiveSearch, 'pepin/interactive_search'
  autoload :GrepFilter,        'pepin/grep_filter'
  autoload :Query,             'pepin/query'
  autoload :CursesView,        'pepin/curses_view'

  class << self
    def search(list, view: nil, filter: nil)
      InteractiveSearch.new(list, view: view, filter: filter).search
    end
  end
end
