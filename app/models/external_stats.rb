# frozen_string_literal: true
class ExternalStats

  attr_accessor :lines

  def initialize(lines)
    @lines = lines
  end

  def as_json(options = {})
    lines.map do |line|
      line.to_json
    end
  end

end
