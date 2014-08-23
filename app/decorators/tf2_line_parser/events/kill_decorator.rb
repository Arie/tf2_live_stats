class TF2LineParser::Events::KillDecorator < TF2LineParser::PvpEventDecorator

  def text
    "#{player.name} killed #{target.name} with #{weapon}"
  end

  def table_class
    if interesting_weapon?
      "warning"
    else
      ""
    end
  end

  def interesting_weapon?
    ["knife", "sniperrifle", "awper_hand", "blutsauger", "proto_syringe", "ubersaw", "crusaders_crossbow"].include?(weapon)
  end

end
