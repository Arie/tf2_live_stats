FROM buildpack-deps:bullseye

# i stole everything below from
# https://github.com/docker-library/ruby/blob/924602dc917e27f8af6b35f838d11e7f3f39b2dc/2.4/stretch/Dockerfile
ENV RUBY_MAJOR 2.4
ENV RUBY_VERSION 2.4.9
ENV RUBY_DOWNLOAD_SHA256 0c4e000253ef7187feeb940a01a1c7594f28d63aa16f978e892a0e2864f58614
ENV RUBYGEMS_VERSION 3.0.3

# some of ruby's build scripts are written in ruby
#   we purge system ruby later to make sure our final image uses what we just built
RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		bison \
		dpkg-dev \
		libgdbm-dev \
		ruby \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz"; \
	echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum --check --strict; \
	\
	mkdir -p /usr/src/ruby; \
	tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1; \
	rm ruby.tar.xz; \
	\
	cd /usr/src/ruby; \
	\
# hack in "ENABLE_PATH_CHECK" disabling to suppress:
#   warning: Insecure world writable dir
	{ \
		echo '#define ENABLE_PATH_CHECK 0'; \
		echo; \
		cat file.c; \
	} > file.c.new; \
	mv file.c.new file.c; \
	\
	autoconf; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--disable-install-doc \
		--enable-shared \
	; \
	make -j "$(nproc)"; \
	make install; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
	cd /; \
	rm -r /usr/src/ruby; \
# make sure bundled "rubygems" is older than RUBYGEMS_VERSION (https://github.com/docker-library/ruby/issues/246)
	ruby -e 'exit(Gem::Version.create(ENV["RUBYGEMS_VERSION"]) > Gem::Version.create(Gem::VERSION))'; \
	gem update --system "$RUBYGEMS_VERSION" && rm -r /root/.gem/; \
# verify we have no "ruby" packages installed
	! dpkg -l | grep -i ruby; \
	[ "$(command -v ruby)" = '/usr/local/bin/ruby' ]; \
# rough smoke test
	ruby --version; \
	gem --version; \
	bundle --version

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
# path recommendation: https://github.com/bundler/bundler/pull/6469#issuecomment-383235438
ENV PATH $GEM_HOME/bin:$BUNDLE_PATH/gems/bin:$PATH
# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"
# (BUNDLE_PATH = GEM_HOME, no need to mkdir/chown both)


# app related envs
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
ENV WEBSOCKET_PORT=9001
ENV HTTP_USERNAME=vtvonly
ENV HTTP_PASSWORD=hahasupersecretfunnypassword
ENV PUBLIC_PORT=3020
ENV DB_NAME=live_log_development
ENV DB_ADDRESS=db
ENV DB_USERNAME=tf2livestats
ENV DB_PASSWORD=anothersuperfunnypassword
ENV SECRET_TOKEN=hahaanothersuperlongandsuperfunnypasswordwhichisverylongtrustme
ENV COOKIE_STORE=_tf2_live_stats_session
ENV REDIS_ADDRESS=redis
ENV REDIS_PORT=6379
ENV MEMCACHED_ADDRESS=memcached
ENV MEMCACHED_PORT=11211

WORKDIR /var/www/tf2_live_stats
COPY . .

RUN cp -r docker/* / && \
  mkdir /var/www/tf2_live_stats/log && \
  ln -s /dev/stdout /var/www/tf2_live_stats/log/production.log && \
  ln -s /dev/stdout /var/www/tf2_live_stats/log/development.log && \
  ln -s /dev/stdout /var/www/tf2_live_stats/log/test.log && \
  ln -s /dev/stdout /var/www/tf2_live_stats/log/thin.${PUBLIC_PORT}.log && \
  ln -s /dev/stdout /var/www/tf2_live_stats/log/websocket_rails.log && \
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
  curl -u $HTTP_USERNAME:$HTTP_PASSWORD --fail localhost:$PUBLIC_PORT || exit 1
