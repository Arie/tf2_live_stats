# TF2 Live Stats

Please read this readme and the license carefully before contacting me about this project, thanks :heart:

This project is a POC that grew out of control and should've been rewritten ages ago, however some people wanted to pull this corpse out of the closet, so here we are, running in Docker!

## Project components
* The main app, based on Ruby 2.4.9
* Memcached
* MySQL/MariaDB database
* Redis

## Installation
Use `docker-compose.yml` in the root of this repository. Make sure you have a modern version of Docker installed and you make your own `.env` file (use `.env.example` for reference). With these two files do `docker compose up -d` and all components should set up and start its operation. Assuming you care about security, you should set up some reverse proxy in front of the web service (UDP listener is being exposed directly).

Here is a configuration example for Nginx (assuming you use a default port for the web service):

```nginx
server {
        listen 80;
        listen [::]:80;
        server_name example.com;
        return 302 https://example.com$request_uri;
}
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name example.com;
        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
        access_log /var/log/nginx/tf2livestats-access.log;
        error_log /var/log/nginx/tf2livestats-error.log;
        #HSTS, optional
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
        #OCSP stapling, optional
        ssl_stapling on;
        ssl_stapling_verify on;
        ssl_session_cache shared:ssl_session_cache:10m;
        ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
        location / {
                proxy_pass http://localhost:3020;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                proxy_set_header X-Forwarded-For $remote_addr;
                }
}
```

## Building

The build process is long, because instead of using a ready Ruby image (based on Debian 9) we build ruby on Debian 11 before the actual app.

```docker
docker buildx build . -t ghcr.io/Arie/tf2_live_stats
```

## Basic overview
TF2 Live Stats consists of 2 parts. The website that displays log events and a log listener daemon, that listens for incoming log lines on a UDP port, parses them and stores them in the database.
Logs are sent to TF2 Live Stats by the TF2 server using the built-in "logaddress_add" command.

The website has 3 pages for live stats:
* The main live stats page is a feed delayed by 90 seconds. It shows most game events and graphs for kills and damage per round. This page is automatically reloaded every 5 seconds.
* The streamer stats is a feed delayed by 70 seconds which focuses on important game events for a streamer, it has no kill/damage graphs. The 70 seconds delay give the streamer a 20 second advance warning to STV, so the streamer can switch to the big plays in time. This page is automatically reloaded every 5 seconds.
* The damage/kills overlay is a dynamically updating page that you can load in OBS and display on stream.


## Adding a match
Open /matches/new. If you enter both ip:port and rcon, the tool will configure the server for you.
If you don't have rcon you'll need someone else to run the command for you. In that case, leave everything blank and hit save, on the next page you'll get an rcon command to copy to someone who will run it for you.

The logsecret is used for servers that already use the logaddress mechanism for other purposes. For example, serveme.tf. You'll need to get the logsecret from the server using 'rcon sv_logsecret' and use that when creating your match on TF2 Live Stats.

Once you've saved the match, you can see a counter of incoming log lines. Refresh this page and make sure you've seen the counter increase above 0 to know Live Stats have been set up properly on the TF2 server.


## Things to keep in mind
* Servers that change the logsecret; stats will not be recorded anymore by the log listener daemon.
* Pauses; this will desync the livestats for 90 seconds. Once the pause happens, livestats will still update for 90 seconds. Once the unpause happens it will be out of sync for 90 seconds.
* Bad network connection between TF2 server and TF2 Live Stats log listener; if for some reason the connection is bad, some log lines might not be received by the log listener. This will cause weird shit to happen, for example if the "Round End" event wasn't received.
Haven't had this happen myself though.
