require 'curses'

class DummyView
  class << self
    attr_accessor :inputs
  end

  def initialize(query)
    @query = query
  end

  def input_char
    self.class.inputs.next
  rescue StopIteration
    Curses::KEY_ENTER
  end

  def cursor; end
  def move_cursor(n); end
  def move_cursor_to_first; end
  def move_cursor_to_last; end

  def shutdown; end
  def refresh_winsize; end
end
