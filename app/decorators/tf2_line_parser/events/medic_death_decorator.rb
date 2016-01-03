# frozen_string_literal: true
class TF2LineParser::Events::MedicDeathDecorator < TF2LineParser::PvpEventDecorator

  decorates_association :target, with: TF2LineParser::MedicDecorator

  def text
    "#{player.name} killed medic #{target_text}"
  end

  def target_text
    if ubercharge
      "#{uberdrop_icon} #{target.name} UBER DROPPED"
    else
      target.name
    end
  end

  def uberdrop_icon
    icon('icon-ambulance icon-large')
  end

  def icon_text
    ''
  end

  def table_class
    "error"
  end

end
