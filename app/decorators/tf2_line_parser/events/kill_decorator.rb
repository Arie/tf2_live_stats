class TF2LineParser::Events::KillDecorator < TF2LineParser::PvpEventDecorator

  def text
    "#{player.name} killed #{target.name} with #{weapon}"
  end

  def table_class
    "warning"
  end

end
