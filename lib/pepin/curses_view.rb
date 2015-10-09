require 'curses'
require 'forwardable'

module Pepin
  class CursesView
    class PromptView
      extend Forwardable

      attr_reader :cursor

      def_delegators :@window, :resize

      def initialize(height, width, y, x, query:, prompt:)
        @query, @prompt_string = query, prompt
        @window = Curses::Window.new(height, width, y, x)
        @cursor = cursor_range.first

        @window.keypad true

        @query.add_observer -> { render }, :call
      end

      def input_char
        @window.getch
      end

      def move_cursor(value)
        self.cursor = cursor + value
      end

      def move_cursor_to_first
        self.cursor = cursor_range.first
      end

      def move_cursor_to_last
        self.cursor = cursor_range.last
      end

      def render
        @window.setpos 0, 0
        @window.addstr @prompt_string + @query.to_s
        @window.clrtoeol
      end

      private

      def cursor_range
        0..@query.length
      end

      def cursor=(pos)
        return false unless cursor_range.include?(pos)

        @cursor = pos

        @window.setpos 0, @prompt_string.length + pos
      end
    end

    class ListView
      extend Forwardable

      def_delegators :@window, :resize

      def initialize(height, width, y, x, query:)
        @query  = query
        @window = Curses::Window.new(height, width, y, x)

        @query.add_observer -> { render }, :call
      end

      def render
        @window.clear

        @query.search.each.with_index 1 do |item, n|
          selected       = n == 1
          matched_offset = @query.pattern ? @query.pattern.match(item).offset(0) : [-1, -1]

          @window.setpos n, 0
          @window.attron Curses::A_UNDERLINE if selected
          item.each_char.with_index do |ch, i|
            @window.attron  Curses::A_BOLD if i == matched_offset[0]
            @window.attroff Curses::A_BOLD if i == matched_offset[1]
            @window.addch ch
          end

          @window.addstr ' ' * (@window.maxx - @window.curx)
          @window.attroff Curses::A_UNDERLINE if selected
          @window.attroff Curses::A_BOLD
        end

        @window.refresh
      end
    end

    extend Forwardable

    def_delegators :@prompt_view, :cursor, :input_char, :move_cursor, :move_cursor_to_first, :move_cursor_to_last

    def initialize(query, prompt: '> ')
      @query         = query
      @prompt_string = prompt

      launch
    end

    def launch
      @window = Curses.init_screen

      Curses.raw
      Curses.noecho

      @prompt_view = PromptView.new(1,                 Curses.cols, 0, 0, query: @query, prompt: @prompt_string)
      @list_view   = ListView.new(  Curses.lines - 1,  Curses.cols, 0, 0, query: @query)

      render
    end

    def render
      @prompt_view.render
      @list_view.render
    end

    def refresh_winsize
      Curses.clear

      lines = Curses.lines
      cols  = Curses.cols

      Curses.resize       lines,     cols
      @window.resize      lines,     cols
      @prompt_view.resize 1,         cols
      @list_view.resize   lines - 1, cols

      render
    end

    def shutdown
      Curses.close_screen if @window
    end
  end
end
