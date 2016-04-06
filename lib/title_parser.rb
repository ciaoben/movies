require 'singleton'

class TitleParser
  include Singleton

  def guessit filename
    response = `guessit "#{filename}"`

    # command not found
    if $?.exitstatus == 127
      raise 'guessit(python module) it has not been found on the system'
    end
    
    get_title response
  end

  private

  def get_title response
    response.match(/"title":\s"(.*)"/)[1]
  end

end