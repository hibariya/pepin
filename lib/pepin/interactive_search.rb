module Pepin
  class InteractiveSearch
    attr_reader :query, :view

    def initialize(list, view: nil, filter: nil)
      @query      = Query.new(list, filter: filter || GrepFilter)
      @view_klass = view || CursesView
    end

    def search
      @view = @view_klass.new(query)

      search_interactive
    ensure
      @view.shutdown if @view
    end

    private

    def search_interactive
      while ch = view.input_char
        handler =
          case ch
          when String                                         then :handle_string
          when Curses::KEY_ENTER, 10                          then :handle_enter
          when Curses::KEY_CTRL_A                             then :handle_ctrl_a
          when Curses::KEY_CTRL_W                             then :handle_ctrl_w
          when Curses::KEY_CTRL_E                             then :handle_ctrl_e
          when Curses::KEY_CTRL_K                             then :handle_ctrl_k
          when Curses::KEY_CTRL_U                             then :handle_ctrl_u
          when Curses::KEY_BACKSPACE, Curses::KEY_CTRL_H, 127 then :handle_backspace
          when Curses::KEY_CTRL_C                             then :handle_ctrl_c
          when Curses::KEY_CTRL_D                             then :handle_ctrl_d
          when Curses::KEY_CTRL_F, Curses::KEY_RIGHT          then :handle_cursor_right
          when Curses::KEY_CTRL_B, Curses::KEY_LEFT           then :handle_cursor_left
          when Curses::KEY_RESIZE                             then :handle_resize
          else                                                     :handle_unknown
          end

        send handler, ch
      end

      result
    rescue StopIteration
      result
    end

    def result
      query.search.first
    end

    def handle_string(ch)
      query.add_char ch
      view.move_cursor 1
    end

    def handle_enter(*)
      raise StopIteration
    end

    def handle_ctrl_a(*)
      view.move_cursor_to_first
    end

    def handle_ctrl_w(*)
      len = query.delete_behind_word_from(view.cursor)

      view.move_cursor -len
    end

    def handle_ctrl_e(*)
      view.move_cursor_to_last
    end

    def handle_ctrl_k(*)
      query.delete_ahead_from view.cursor
    end

    def handle_ctrl_u(*)
      query.delete_behind_from view.cursor

      view.move_cursor_to_first
    end

    def handle_backspace(*)
      query.delete_behind_char_from view.cursor

      view.move_cursor -1
    end

    def handle_ctrl_c(*)
      exit
    end

    def handle_ctrl_d(*)
      exit if query.empty?
    end

    def handle_cursor_right(*)
      view.move_cursor 1
    end

    def handle_cursor_left(*)
      view.move_cursor -1
    end

    def handle_resize(*)
      view.refresh_winsize
    end

    def handle_unknown(*)
      # Intentionally NOP
    end
  end
end
