#!/bin/bash
#Replacing values with vars given to the container
/bin/sed "s/LOG_LISTENER_ADDRESS/$LOG_LISTENER_ADDRESS/g" /var/www/tf2_live_stats/script/listener
/bin/sed "s/LOG_LISTENER_ADDRESS/$LOG_LISTENER_ADDRESS/g" /var/www/tf2_live_stats/app/models/match.rb
/bin/sed "s/LOG_LISTENER_ADDRESS/$LOG_LISTENER_ADDRESS/g" /var/www/tf2_live_stats/app/views/matches/show.html.haml
/bin/sed "s/LOG_LISTENER_PORT/$LOG_LISTENER_PORT/g" /var/www/tf2_live_stats/app/models/match.rb
/bin/sed "s/LOG_LISTENER_PORT/$LOG_LISTENER_PORT/g" /var/www/tf2_live_stats/app/views/matches/show.html.haml
/bin/sed "s/WEB_INTERFACE_ADDRESS/$WEB_INTERFACE_ADDRESS/g" /var/www/tf2_live_stats/app/views/matches/show.html.haml
/bin/sed "s/HTTP_USERNAME/$HTTP_USERNAME/g" /var/www/tf2_live_stats/app/controllers/matches_controller.rb
/bin/sed "s/HTTP_USERNAME/$HTTP_USERNAME/g" /var/www/tf2_live_stats/app/controllers/pages_controller.rb
/bin/sed "s/HTTP_PASSWORD/$HTTP_PASSWORD/g" /var/www/tf2_live_stats/app/controllers/matches_controller.rb
/bin/sed "s/HTTP_PASSWORD/$HTTP_PASSWORD/g" /var/www/tf2_live_stats/app/controllers/pages_controller.rb
/bin/sed "s/PUBLIC_PORT/$PUBLIC_PORT/g" /var/www/tf2_live_stats/script/websockets
/bin/sed "s/DB_NAME/$DB_NAME/g" /var/www/tf2_live_stats/config/database.yml
/bin/sed "s/DB_ADDRESS/$DB_ADDRESS/g" /var/www/tf2_live_stats/config/database.yml
/bin/sed "s/DB_USERNAME/$DB_USERNAME/g" /var/www/tf2_live_stats/config/database.yml
/bin/sed "s/DB_PASSWORD/$DB_PASSWORD/g" /var/www/tf2_live_stats/config/database.yml
/bin/sed "s/SECRET_TOKEN/$SECRET_TOKEN/g" /var/www/tf2_live_stats/config/initializers/secret_token.rb
/bin/sed "s/COOKIE_STORE/$COOKIE_STORE/g" /var/www/tf2_live_stats/config/initializers/session_store.rb