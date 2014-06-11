class TF2LineParser::Events::SpawnDecorator < TF2LineParser::Events::RoleChangeDecorator

  def text
    "#{player.name} spawned as #{role_text}"
  end

end
