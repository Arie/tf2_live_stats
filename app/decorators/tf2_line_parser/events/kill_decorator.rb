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
    [
    #Scout
    "bat", "bat_fish", "bat_wood", "atomizer", "ball", "boston_basher", "cleaver", "guilotine", "holy_mackerel", "sandman", "scout_sword", "warfan",
    #Soldier
    "unique_pickaxe_escape", "shovel", "disciplinary_action", "mantreads", "market_gardener", "taunt_soldier",
    #Pyro
    "deflect_rocket", "deflect_arrow", "deflect_promode", "fireaxe", "powerjack", "taunt_pyro",
    #Demoman
    "ullapool_caber_explosion", "ullapool_caber", "bottle", "club",
    #Heavy
    "steel_fists", "fists", "taunt_heavy",
    #Engineer
    "mechanical_arm", "southern_hospitality", "taunt_engineer", "wrench", "wrench_jag",
    #Medic
     "blutsauger", "proto_syringe", "ubersaw", "bonesaw", "crusaders_crossbow", "syringegun_medic", "taunt_medic",
    #Sniper
    "sniperrifle", "awper_hand", "machina", "classic", "hitman_heatmaker", "bazaar_bargain", "bushwacka", "sniperrifle_classic", "sniperrifle_decap", "taunt_sniper", "pro_rifle",
    #Spy
    "knife", "black_rose", "spy_cicle", "voodoo_pin",
    #Multi
    "freedom_staff", "fryingpan", "paintrain",
    ].include?(weapon)
  end

end
