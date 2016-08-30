require 'unit_split'
require 'io/wait'
require 'optparse'

class UnitSplit::CLI

  class << self

    def bootstrap(argv)
      unit_type = nil
      parser = OptionParser.new
      parser.on('-s', 'seconds') { unit_type = :second }
      parser.on('-b', 'bytes')   { unit_type = :byte  }
      parser.on('-j', 'japanese number') { unit_type = :japanese }

      target = nil
      begin
        target = parser.parse!(argv)
        if target.kind_of? Array
          target = target.first
        end
      rescue OptionParser::MissingArgument => e
        abort(e.to_s)
      end
      
      if target.nil? || target.empty?
        if $stdin.ready?
          target = $stdin.readline.strip
        else
          abort "specify target number"
        end
      end

      unless unit_type
        abort "unit not specified"
      end

      unit = dispatch_unit(unit_type)
      unless unit
        abort "unknown unit type"
      end

      result = UnitSplit.split(target, unit)
      format_print result
    end

    def dispatch_unit(unit_type)
      case unit_type
      when :second
        return UnitSplit::Unit::Second
      when :byte
        return UnitSplit::Unit::Byte
      when :japanese
        return UnitSplit::Unit::JapaneseNumber
      else
        return nil
      end
    end

    def format_print(result)
      max_value_length = 1
      max_label_length = 1

      # check label/value length
      result.each do |entry|
        label = entry[0]
        value = entry[1]
        if label && label.length > max_label_length
          max_label_length = label.length
        end
        if value && value.to_s.length > max_value_length
          max_value_length = value.to_s.length
        end
      end

      result.reverse.each do |entry|
        puts "%#{max_value_length}d %-#{max_label_length}s" %
          [entry[1], entry[0]]
      end
    end

  end


end
