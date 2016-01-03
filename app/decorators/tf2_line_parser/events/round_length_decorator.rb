# frozen_string_literal: true
class TF2LineParser::Events::RoundLengthDecorator < TF2LineParser::EventDecorator

  def text
    "Round lasted #{length} seconds"
  end

end
