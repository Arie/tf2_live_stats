WebsocketRails::EventMap.describe do
  subscribe :current_damage,  :to => OverlayController, :with_method => :current_damage
  subscribe :current_kills,   :to => OverlayController, :with_method => :current_kills
  subscribe :last_damage,     :to => OverlayController, :with_method => :last_damage
  subscribe :last_kills,      :to => OverlayController, :with_method => :last_kills
  subscribe :spawn_kills,     :to => OverlayController, :with_method => :spawn_kills
end
