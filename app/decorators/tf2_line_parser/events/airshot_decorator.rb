class TF2LineParser::Events::AirshotDecorator < TF2LineParser::Events::DamageDecorator

  def text
    "#{airshot_icon} #{player.name} hit an AIRSHOT with #{weapon} for #{value} damage #{airshot_icon}"
  end

  def airshot_icon
    icon('icon-cloud icon-large')
  end

  def icon_text
    ''
  end

  def table_class
    "error"
  end

end
