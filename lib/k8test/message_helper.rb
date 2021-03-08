require 'rainbow/refinement'
using Rainbow
class MessageHelper

  CLEAR_LINE = "\e[0E"
  OK_EMOJI = '💃'.freeze
  DO_EMOJI = '⚙️'.freeze
  DONE_EMOJI = '✔️'.freeze
  PROGRESS_EMOJIS = '🙈🙉🙊'.freeze

  ERROR_EMOJI = '😱'.freeze
  WARNING_EMOJI = '⚠️ '.freeze
  PROGRESS_MESSAGE_EMOJI = '🔧'.freeze
  TAB = '      '.freeze

  # Helper method for message output
  def self.say_with_prefix(prefix, message, color = nil)
    message.each_line do |line|
      puts Rainbow("#{prefix}#{line}").send(color)
    end
  rescue Encoding::CompatibilityError
    puts '?'
  end

  # Helper method for message output
  def self.say(message)
    print "#{TAB}#{message}"
  end

  def self.progress_message(message)
    say_with_prefix("#{PROGRESS_MESSAGE_EMOJI}#{TAB}", message, :green)
  end

  def self.warning(message)
    say_with_prefix("#{WARNING_EMOJI}#{TAB}", message, :yellow)
  end

  def self.do_or_done(message:, &block)
    print CLEAR_LINE + DO_EMOJI + TAB + message.black.bright
    result = progress { yield }

    done(message) if result.already_done?
    error(message) if result.error?
    ok(message) if result.ok?
  end

  def self.progress_message
    @progress_index ||= 0
    print CLEAR_LINE + PROGRESS_EMOJIS[(@progress_index += 1) % 3]
  end

  def self.progress(&block)
    thread = Thread.new do
      while true do
        progress_message
        sleep 1
      end
    end
    sleep 1
    result = yield
    thread.kill
    return result
  end

  def self.error(message)
    puts("#{CLEAR_LINE}#{ERROR_EMOJI}#{TAB} " + message.red + "\n")
  end

  def self.ok(message)
    puts("#{CLEAR_LINE}#{OK_EMOJI}#{TAB} " + message.green+ "\n")
  end

  def self.done(message)
    puts("#{CLEAR_LINE}#{DONE_EMOJI}#{TAB} " + message.green+ "\n")
  end

  def self.say_indented(message, color = nil)
    say_with_prefix(" #{TAB}", message, color)
  end

end

