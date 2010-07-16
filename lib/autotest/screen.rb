require 'rubygems'
require 'autotest'
require 'rbconfig'

require 'autotest/result'

module Autotest::Screen

  def self.green( text )
    "%{dG}#{text}"
  end

  def self.red( text )
    "%{dR}#{text}"
  end

  def self.yellow( text )
    "%{dy}#{text}"
  end

  def self.screen_pid( pid=Process.ppid )
    @screen_pid ||= lambda {
      status = File.read( "/proc/#{pid}/stat" )
      unless status =~ /(\d+) \((.*?)\) \w (\d+)/
        raise "Trouble reading status of process #{pid}"
      end

      pid, exe, ppid = $1, $2, $3
      if exe =~ /^screen/i
        pid
      else
        screen_pid( ppid )
      end
    }.call
  end

  def self.screen_caption=( caption )
    system %Q{ screen -S #{screen_pid} -X eval 'caption always "#{caption}"' }
  rescue
    STDERR.puts "Unable to find parent screen process."
    STDERR.puts $!.message
    STDERR.puts $!.backtrace.join( "\n" )
  end

  def self.clear_screen_caption
    system %Q{ screen -S #{screen_pid} -X eval 'caption splitonly' }
  rescue
    STDERR.puts "Unable to find parent screen process."
    STDERR.puts $!.message
    STDERR.puts $!.backtrace.join( "\n" )
  end


  def self.update( kind, num=nil, total=num )
    case kind
    when :failure
      self.screen_caption = red(
        " #{num} failed from #{total}."
      )
    when :pending
      self.screen_caption = yellow(
        " #{num} pending from #{total}."
      )
    when :success
      self.screen_caption = green(
        " #{num} passed."
      )
    when :error
      self.screen_caption = red( " Error running tests." )
    else
      raise "Unexpected kind of update #{kind}"
    end
  end


  ##
  # Parse the RSpec and Test::Unit results and send them to Growl.
  Autotest.add_hook :ran_command do |autotest|
    result = Autotest::Result.new( autotest )
    if result.exists?
      case result.framework
      when 'rspec'
        if result.has?( 'example-failed' )
          update :failure, result[ 'example-failed' ], result[ 'example' ]
        elsif result.has?( 'example-pending' )
          update :pending, result[ 'example-pending' ], result[ 'example' ]
        else
          update :success, result.get( 'example' )
        end
      end
    else
      update :error
    end

    false
  end

  Autotest.add_hook( :died ){ clear_screen_caption }
  Autotest.add_hook( :quit ){ clear_screen_caption }
end
