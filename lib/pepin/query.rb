require 'forwardable'
require 'observer'

module Pepin
  class Query
    extend Forwardable
    include Observable

    def_delegators :@string, :length, :empty?, :to_s

    def initialize(list, filter: GrepFilter)
      @list   = list
      @string = ''
      @filter = filter.new
    end

    def pattern
      @filter.pattern(@string.strip)
    end

    def search
      @filter.select(@list, @string.strip)
    end

    def clear
      @string.clear

      notify_change
    end

    def add_char(ch)
      @string << ch

      notify_change
    end

    def delete_behind_word_from(pos)
      string_was = @string
      @string    = @string[0..pos.pred].split(/\b/)[0...-1].join + @string[pos..-1]

      notify_change

      string_was.length - @string.length
    end

    def delete_behind_char_from(pos)
      @string = @string[0...pos.pred] + @string[pos..-1]

      notify_change

      1
    end

    def delete_ahead_from(pos)
      string_was = @string
      @string    = @string.to_s[0...pos]

      notify_change

      string_was.length - @string.length
    end

    private

    def notify_change
      changed
      notify_observers
    end
  end
end
