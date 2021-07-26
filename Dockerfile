ARG _RUBY_VERSION=2.7.2
FROM ruby:${_RUBY_VERSION}
LABEL maintainer "Embras Labs <labs@embras.net>"

ARG _RUBY_VERSION=2.7.2
RUN echo ">>>>>>>>> _RUBY_VERSION=${_RUBY_VERSION}"

EXPOSE 3000
WORKDIR /app

ARG _USER=home/labs

ENV TZ=Etc/UTC

RUN apt-get update -qq && \
	apt-get install -y libpq-dev nodejs build-essential locales firebird-dev tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    adduser labs && mkdir /.gems

ENV LANG C.UTF-8

COPY ./.irbrc /${_USER}
COPY ./.pryrc /${_USER}
COPY ./.bashrc /${_USER}

COPY ./.irbrc /root
COPY ./.pryrc /root
COPY ./.bashrc /root

# Reference: https://github.com/jfroom/docker-compose-rails-selenium-example
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-entrypoint.sh

# Add bundle entry point to handle bundle cache
ENV BUNDLE_PATH=/.gems \
    BUNDLE_BIN=/.gems/bin \
    GEM_HOME=/.gems
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem install terminal-table --version=3.0.0
RUN gem install pry-byebug
RUN gem install awesome_print

RUN chown -R labs:labs /.gems