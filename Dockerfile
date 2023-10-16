FROM ruby:2.4.9-stretch
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG USERNAME=tf2livestats
ARG UID=1000
ARG GID=1000

ENV S6_KEEP_ENV=1
ENV RAILS_ENV=production
ENV BUNDLE_DEPLOYMENT=true
ENV BUNDLE_PATH=/var/www/tf2_live_stats/vendor/bundle
ENV LOG_LISTENER_ADDRESS=0.0.0.0
ENV LOG_LISTENER_PORT=20001
ENV WEB_INTERFACE_ADDRESS=0.0.0.0
ENV HTTP_USERNAME=vtvonly
ENV HTTP_PASSWORD=hahasupersecretfunnypassword
ENV PUBLIC_PORT=3000
ENV DB_NAME=live_log_development
ENV DB_ADDRESS=db
ENV DB_USERNAME=tf2livestats
ENV DB_PASSWORD=anothersuperfunnypassword
ENV SECRET_TOKEN=hahaanothersuperlongandsuperfunnypasswordwhichisverylongtrustme
ENV COOKIE_STORE=_tf2_live_stats_session
ENV REDIS_ADDRESS=redis
ENV REDIS_PORT=6379

WORKDIR /var/www/tf2_live_stats
COPY . .

RUN cp -r docker/* / && \
  groupadd -g $GID -o $USERNAME && \
  useradd -m -d /var/www/tf2_live_stats -u $UID -g $GID -o -s /bin/bash $USERNAME && \
  chown -R $UID:$GID /var/www/tf2_live_stats

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz


USER $USERNAME
RUN DEBUG_RESOLVER=1 bundle install --verbose && \
  bundle exec rake assets:precompile
  

ENTRYPOINT ["/init"]
HEALTHCHECK --interval=15s --timeout=5s --retries=3 CMD \
  curl -u $HTTP_USERNAME:$HTTP_PASSWORD --fail localhost:3020 || exit 1
