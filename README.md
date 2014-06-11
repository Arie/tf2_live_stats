# TF2 Live Stats
==============

## Requirements
* Ruby 1.9+
* Experience running Ruby/Rails apps

## Installation
Assuming you'll have experience with running Rails apps, you'll know what to do. The web part of TF2 Live Stats should run in any ruby app server or passenger.

## Basic overview
TF2 Live Stats consists of 2 parts. The website that displays log events and a log listener daemon, that listens for incoming log lines on a UDP port, parses them and stores them in the database.
Logs are sent to TF2 Live Stats by the TF2 server using the built-in "logaddress_add" command.

The website has 3 pages for live stats:
* The main live stats page is a feed delayed by 90 seconds. It shows most game events and graphs for kills and damage per round. This page is automatically reloaded every 5 seconds.
* The streamer stats is a feed delayed by 70 seconds which focuses on important game events for a streamer, it has no kill/damage graphs. The 70 seconds delay give the streamer a 20 second advance warning to STV, so the streamer can switch to the big plays in time. This page is automatically reloaded every 5 seconds.
* The damage/kills overlay is a dynamically updating page that you can load in OBS and display on stream.


## Adding a match
Open /matches/new. If you enter both ip:port and rcon, the tool will configure the server for you. Don't forget to find and replace 'fakkelbrigade.eu:20001', with your own stuff.
If you don't have rcon you'll need someone else to run the command for you. In that case, leave everything blank and hit save, on the next page you'll get an rcon command to copy to someone who will run it for you.

The logsecret is used for servers that already use the logaddress mechanism for other purposes. For example, serveme.tf. You'll need to get the logsecret from the server using 'rcon sv_logsecret' and use that when creating your match on TF2 Live Stats.

Once you've saved the match, you can see a counter of incoming log lines. Refresh this page and make sure you've seen the counter increase above 0 to know Live Stats have been set up properly on the TF2 server.


## Things to keep in mind
* Servers that change the logsecret; stats will not be recorded anymore by the log listener daemon.
* Pauses; this will desync the livestats for 90 seconds. Once the pause happens, livestats will still update for 90 seconds. Once the unpause happens it will be out of sync for 90 seconds.
* Bad network connection between TF2 server and TF2 Live Stats log listener; if for some reason the connection is bad, some log lines might not be received by the log listener. This will cause weird shit to happen, for example if the "Round End" event wasn't received.
Haven't had this happen myself though.
