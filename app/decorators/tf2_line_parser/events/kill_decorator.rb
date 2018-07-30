# frozen_string_literal: true
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
    "bat", "atomizer", "ball", "bat_fish", "bat_wood", "batsaber", "boston_basher", "candy_cane", "cleaver", "guilotine", "holymackerel", "lava_bat", "sandman", "scout_sword", "unarmed_combat", "warfan", "wrap_assassin", "taunt_scout",
    #Soldier
    "shovel",  "disciplinary_action", "mantreads", "market_gardener", "unique_pickaxe_escape", "unique_pickaxe", "taunt_soldier", "taunt_soldier_lumbricus",
    #Pyro
    "fireaxe", "annihilator", "axtinguisher", "back_scratcher", "gas_blast", "hot_hand", "lava_axe", "lollichop", "powerjack", "mailbox", "rocketpack", "rocketpack_stomp", "sledgehammer", "the_maul", "thirddegree", "taunt_pyro",
    #Demoman
    "bottle", "claidheamohmor", "demoshield", "headtaker", "nessieclub", "persian_persuader", "scotland_shard", "splendid_screen", "sword", "tide_turner", "ullapool_caber_explosion", "ullapool_caber",
    #Heavy
    "fists", "apocofists", "bread_bite", "eviction_notice", "gloves", "gloves_running_urgently", "holiday_punch", "steel_fists", "warrior_spirit", "taunt_heavy",
    #Engineer
    "wrench", "eureka_effect", "mechanical_arm", "robot_arm", "robot_arm_blender_kill", "robot_arm_combo_kill", "short_circuit", "southern_hospitality", "wrench_jag", "wrench_golden", "taunt_engineer", "taunt_guitar_kill",
    #Medic
    "syringegun_medic", "bonesaw", "battleneedle", "blutsauger", "crusaders_crossbow", "proto_syringe", "amputator", "solemn_vow", "ubersaw", "taunt_medic",
    #Sniper
    "sniperrifle", "awper_hand", "bazaar_bargain", "classic", "hitman_heatmaker", "pro_rifle", "sydney_sleeper", "sniperrifle_classic", "sniperrifle_decap", "the_classic", "taunt_sniper",
    "huntsman", "huntsman_burning", "huntsman_flyingburn", "huntsman_flyingburn_headshot", "huntsman_headshot", "tf_projectile_arrow",
    "machina", "shooting_star", "player_penetration", "headshot_player_penetration",
    "club", "bushwacka", "shahanshah", "tribalkukri",
    #Spy
    "knife", "ambassador_headshot", "black_rose", "big_earner", "eternal_reward", "kunai", "sharp_dresser", "sharp_dresser_backstab", "spy_cicle", "voodoo_pin", "taunt_spy",
    #Multi
    "battleaxe", "crossing_guard", "demokatana", "freedom_staff", "fryingpan", "golden_fryingpan", "ham_shank", "memory_maker", "necro_smasher", "nonnonviolent_protest", "paintrain", "prinny_machete", "saxxy", "skullbat",
    #Bonus
    "bleed_kill", "player", "telefrag",
    #Reflects
    "deflect_arrow", "deflect_ball", "deflect_flare", "deflect_huntsman_headshot", "deflect_huntsman_flyingburn", "deflect_huntsman_flyingburn_headshot", "deflect_promode", "deflect_rocket", "deflect_sticky", "rescue_ranger_reflect",
    #Environmental
    "pumpkindeath", "saw_kill", "vehicle", "world",
    ].include?(weapon)
  end

end
