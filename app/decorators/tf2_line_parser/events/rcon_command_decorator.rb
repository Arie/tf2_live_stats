# frozen_string_literal: true
class TF2LineParser::Events::RconCommandDecorator < TF2LineParser::EventDecorator

  def message_text
    icon('icon-comment')
  end

  def icon_text
    content_tag(:em, message)
  end

  def text
    message
  end
end
