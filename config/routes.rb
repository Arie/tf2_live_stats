Tf2LiveStats::Application.routes.draw do
  root :to => "matches#new"

  match "/log/:match_id"                => "pages#log"
  match "/stats/:match_id"              => "pages#stats"
  match "/streamer_stats/:match_id"     => "pages#streamer_stats"
  match "/damage/last/:match_id"        => "pages#last_damage"
  match "/damage/current/:match_id"     => "pages#current_damage"
  match "/kills/last/:match_id"         => "pages#last_kills"
  match "/kills/current/:match_id"      => "pages#current_kills"
  match "/overlay/:match_id"            => "pages#overlay"
  match "/live/:match_id"               => "pages#public"
  match "/external_stats/:match_id"     => "pages#external"

  resources :pages do
    collection do
      get :log
      get :stats
      get :public
      get :streamer_stats
      get :overlay
    end
  end

  resources :matches

end
