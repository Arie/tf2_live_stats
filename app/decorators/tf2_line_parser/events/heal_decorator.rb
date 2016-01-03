# frozen_string_literal: true
class TF2LineParser::Events::HealDecorator < TF2LineParser::PvpEventDecorator

  def text
    "#{player.name} healed #{target.name} for #{value} hp"
  end

end
