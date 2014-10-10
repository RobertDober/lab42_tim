
require 'colored'

class TestResultParser

  GREEN_DOT   = ".".green
  RED_ERROR   = "E".red
  RED_FAILURE = "F".red

  attr_reader :errors, :failed, :messages, :passed

  def parse lines
    lines.each{ | line | parse_line line }
  end


  def resumee
    $stdout.puts

    put_messages
    put_resumee

    ok? ? exit(0) : exit(1)
  end


  private
  def initialize
    @errors = @passed = @failed = 0
    @messages = []
  end

  def ok?; (errors + failed).zero? end

  def parse_line line
    line = line.strip
    case line
    when /\Apassed/
      @passed += 1
      $stdout.print GREEN_DOT
    when /\Afailed (.*)/
      messages << $1
      @failed += 1
      $stdout.print RED_FAILURE
    else
      messages << line
      @errors += 1
      $stdout.print RED_ERROR
    end
  end

  def pluralize n, name='item', pform = nil
    return "1 #{name}" if n == 1
    "#{n} #{pform || "#{name}s"}"
  end

  def put_messages
    return if messages.empty?
    $stdout.puts
    messages.each do | message |
      put_message message
    end
  end


  def put_resumee
    message = [pluralize(steps, "step"), pluralize(failed, "failure"), pluralize(errors, "error")].join ", "
    message = ok? ? message.green : message.red

    $stdout.puts
    $stdout.puts message
  end

  def put_message message
    $stdout.puts message.red
  end

  def steps; failed + passed end
end
