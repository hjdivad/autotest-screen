# encoding: utf-8

require 'rubygems'
require 'autotest'
require 'autotest-screen'


# Track original $stdout, $stderr write methods so we can “unmock” them for
# debugging

class << $stdout
  alias_method :real_write, :write
end
class << $stderr
  alias_method :real_write, :write
end


class Object
  def debug
    # For debugging, restore stubbed write
    class << $stdout
      alias_method :write, :real_write
    end
    class << $stderr
      alias_method :write, :real_write
    end

    require 'ruby-debug'
    debugger
  end
end
