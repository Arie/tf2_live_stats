source 'https://rubygems.org'

gem 'rails', :github => "rails/rails", :branch => "4-2-stable"
gem 'haml'
gem 'thin',             :require => false
gem 'omniauth-openid'
gem 'omniauth-steam'
gem 'devise', require: false
gem 'simple_form'
gem 'steam-condenser', :github => 'koraktor/steam-condenser-ruby'
gem 'logs_tf'
gem 'sys-proctable',    :require => 'sys/proctable'
gem 'tf2_line_parser',  :github => "Arie/tf2_line_parser"
gem 'draper'
gem 'mysql2'
gem "google_visualr",   :github => "Arie/google_visualr"
gem 'request_store'
gem 'dalli'
gem 'turbolinks'
gem 'eventmachine'
gem 'websocket-rails'
gem 'protected_attributes'
gem 'redis', '< 4.0'
gem 'actionpack-page_caching'

group :development do
  gem "query_reviewer", :git => "git://github.com/nesquena/query_reviewer.git"
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'

  #Deployment
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'capistrano'
  gem 'rvm-capistrano', require: false
end

group :test, :development do
  gem 'pry-nav'
end

group :test_tools do
  gem 'fuubar'
end

group :assets, :test do
  gem "libv8"
end

group :assets do
  gem 'uglifier'
  gem 'jquery-rails'
  gem 'compass-rails'
  gem 'oily_png'
  gem 'sass-rails'
  gem 'bootstrap-sass', "~> 2.3"
  gem 'therubyracer', :require => 'v8'
  gem 'font-awesome-sass-rails'
end
