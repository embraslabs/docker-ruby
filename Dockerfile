ARG _IMAGE_TYPE=api
ARG _RUBY_VERSION=2.7.2
ARG _USER=home/labs

FROM ruby:${_RUBY_VERSION} as base-api
LABEL maintainer "Embras Labs <labs@embras.net>"

ENV TZ=Etc/UTC
ENV LANG C.UTF-8

RUN apt-get update -qq && \
	apt-get install -y libpq-dev nodejs build-essential locales firebird-dev tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    adduser labs && mkdir /.gems

FROM base-api AS base-fullstack
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

ARG _USER=home/labs
ARG _IMAGE_TYPE=api
FROM base-${_IMAGE_TYPE} as final

EXPOSE 3000
WORKDIR /project

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

RUN gem install bundler:2.1.4
RUN gem install terminal-table --version=3.0.0
RUN gem install pry-byebug
RUN gem install awesome_print

RUN chown -R labs:labs /.gems