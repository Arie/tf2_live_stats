FROM ruby:2.4.9-stretch
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG USERNAME=tf2livestats
ARG UID=1000
ARG GID=1000
# throw errors if Gemfile has been modified since Gemfile.lock
#RUN bundle config --global frozen 1

WORKDIR /var/www/tf2_live_stats

COPY . .

RUN chmod +x start.sh && \
  cp -r docker/* / && \
  groupadd -g $GID -o $USERNAME && \
  useradd -m -u $UID -g $GID -o -s /bin/bash $USERNAME && \
  chown -R $UID:$GID /var/www/tf2_live_stats

# COPY Gemfile Gemfile.lock ./
USER $USERNAME
RUN bundle config github.https true && \
  DEBUG_RESOLVER=1 bundle install --verbose

#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
#RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
#RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz


  

ENV LOG_LISTENER_ADDRESS=fakkelbrigade.eu
ENV LOG_LISTENER_PORT=20001
ENV WEB_INTERFACE_ADDRESS=0.0.0.0
ENV HTTP_USERNAME=vtvonly
ENV HTTP_PASSWORD=hahasupersecretfunnypassword
ENV PUBLIC_PORT=3000
ENV DB_NAME=live_log_development
ENV DB_ADDRESS=tf2livestats-db
ENV DB_USERNAME=tf2livestats
ENV DB_PASSWORD=anothersuperfunnypassword
ENV SECRET_TOKEN=hahaanothersuperlongandsuperfunnypasswordwhichisverylongtrustme
ENV COOKIE_STORE=_tf2_live_stats_session
CMD ["/var/www/tf2_live_stats/start.sh"]
#ENTRYPOINT ["/init"]
