# frozen_string_literal: true
class TF2LineParser::Events::HeadshotDamageDecorator < TF2LineParser::PlayerEventDecorator

  def crosshair_icon
    icon('icon-crosshairs icon-large')
  end

  def icon_text
    ''
  end

  def table_class
    "warning"
  end

  def text
    "#{crosshair_icon} #{player.name} made a headshot for #{value} damage"
  end

end
