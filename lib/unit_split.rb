require "unit_split/version"
require "unit_split/unit"

module UnitSplit

  def self.split(text, unit)
    if text.nil? || 0 == text.length
      raise ArgumentError, "invalid input"
    end

    number = text.to_i
    response = []

    last_label = nil
    value  = nil
    remain = nil

    unit.each do |entry|
      label   = entry[0]
      divider = entry[1]

      value  = (number / divider)
      remain = (number % divider)

      # puts "----------"
      # puts "number = " + number.to_s
      # puts "value  = " + value.to_s
      # puts "remain = " + remain.to_s

      response.push([last_label, remain])

      if value == 0
        return response
      end

      last_label = label
      number = value
    end

    if value > 0
      response.push([last_label, value])
    end
    return response
  end

end

