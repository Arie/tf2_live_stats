Tf2LiveStats::Application.routes.draw do
  root :to => "matches#new"

  get "/log/:match_id"                => "pages#log"
  get "/stats/:match_id"              => "pages#stats"
  get "/streamer_stats/:match_id"     => "pages#streamer_stats"
  get "/damage/last/:match_id"        => "pages#last_damage"
  get "/damage/current/:match_id"     => "pages#current_damage"
  get "/kills/last/:match_id"         => "pages#last_kills"
  get "/kills/current/:match_id"      => "pages#current_kills"
  get "/overlay/:match_id"            => "pages#overlay"
  get "/live/:match_id"               => "pages#public"
  get "/external_stats/:match_id"     => "pages#external"

  post "/cevo/match" => "cevo_matches#create"

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
