#!/usr/bin/with-contenv
cd /var/www/tf2_live_stats
# replacing values with vars given to the container
/bin/sed -ie "s/LOG_LISTENER_ADDRESS/$LOG_LISTENER_ADDRESS/g" app/models/match.rb
/bin/sed -ie "s/LOG_LISTENER_ADDRESS/$LOG_LISTENER_ADDRESS/g" app/views/matches/show.html.haml
/bin/sed -ie "s/LOG_LISTENER_PORT/$LOG_LISTENER_PORT/g" app/models/match.rb
/bin/sed -ie "s/LOG_LISTENER_PORT/$LOG_LISTENER_PORT/g" app/views/matches/show.html.haml
/bin/sed -ie "s/LOG_LISTENER_PORT/$LOG_LISTENER_PORT/g" script/listener
/bin/sed -ie "s/WEBSOCKET_PORT/$WEBSOCKET_PORT/g" app/views/matches/show.html.haml
/bin/sed -ie "s/HTTP_USERNAME/$HTTP_USERNAME/g" app/controllers/matches_controller.rb
/bin/sed -ie "s/HTTP_USERNAME/$HTTP_USERNAME/g" app/controllers/pages_controller.rb
/bin/sed -ie "s/HTTP_PASSWORD/$HTTP_PASSWORD/g" app/controllers/matches_controller.rb
/bin/sed -ie "s/HTTP_PASSWORD/$HTTP_PASSWORD/g" app/controllers/pages_controller.rb
/bin/sed -ie "s/PUBLIC_PORT/$PUBLIC_PORT/g" script/websockets
/bin/sed -ie "s/DB_NAME/$DB_NAME/g" config/database.yml
/bin/sed -ie "s/DB_ADDRESS/$DB_ADDRESS/g" config/database.yml
/bin/sed -ie "s/DB_USERNAME/$DB_USERNAME/g" config/database.yml
/bin/sed -ie "s/DB_PASSWORD/$DB_PASSWORD/g" config/database.yml
/bin/sed -ie "s/SECRET_TOKEN/$SECRET_TOKEN/g" config/initializers/secret_token.rb
/bin/sed -ie "s/COOKIE_STORE/$COOKIE_STORE/g" config/initializers/session_store.rb
/bin/sed -ie "s/REDIS_ADDRESS/$REDIS_ADDRESS/g" config/initializers/websocket_rails.rb
/bin/sed -ie "s/REDIS_PORT/$REDIS_PORT/g" config/initializers/websocket_rails.rb
/bin/sed -ie "s/MEMCACHED_ADDRESS/$MEMCACHED_ADDRESS/g" config/environments/development.rb
/bin/sed -ie "s/MEMCACHED_PORT/$MEMCACHED_PORT/g" config/environments/development.rb
/bin/sed -ie "s/MEMCACHED_ADDRESS/$MEMCACHED_ADDRESS/g" config/environments/production.rb
/bin/sed -ie "s/MEMCACHED_PORT/$MEMCACHED_PORT/g" config/environments/production.rb
/bin/echo "Initializing DB..."
bundle exec rake db:create db:migrate db:seed