require 'unit_split'
require 'io/wait'
require 'optparse'

class UnitSplit::CLI

  class << self

    def bootstrap(argv)
      unit = nil
      parser = OptionParser.new
      parser.on('-s', 'seconds') { unit = :second }
      parser.on('-b', 'bytes')   { unit = :bytes  }
      parser.on('-j', 'japanese number') { unit = :japanese }

      target = nil
      begin
        target = parser.parse!(argv)
      rescue OptionParser::MissingArgument => e
        abort(e.to_s)
      end
      
      unless unit
        abort "unit not specified"
      end

      if target.nil? || target.empty?
        if $stdin.ready?
          target = $stdin.readline.strip
        else
          abort "specify target number"
        end
      end

    end

  end


end
