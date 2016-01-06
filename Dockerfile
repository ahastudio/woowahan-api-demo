FROM ubuntu:14.04

WORKDIR /tmp

RUN apt-get update                                                  && \
    apt-get upgrade -y                                              && \
    apt-get install -y curl git-core build-essential nodejs         \
                       autoconf bison libssl-dev libyaml-dev        \
                       libreadline6-dev zlib1g-dev libncurses5-dev  \
                       libffi-dev libgdbm3 libgdbm-dev              \
                       libmysqlclient-dev                           && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv     && \
    git clone https://github.com/sstephenson/ruby-build.git         \
              ~/.rbenv/plugins/ruby-build                           && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc        && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc                      && \
    export PATH="$HOME/.rbenv/bin:$PATH"                            && \
    rbenv install 2.3.0                                             && \
    rbenv global 2.3.0                                              && \
    eval "$(rbenv init -)"                                          && \
    gem update --system                                             && \
    gem install bundler                                             && \
    rbenv rehash                                                    && \
    rm ruby-build.*.log

ENV RBENV_ROOT /root/.rbenv
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH

ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock

RUN bundle install --binstubs --without development:test

ADD . /webapp

RUN mv /tmp/.bundle /webapp/  && \
    rm -rf /webapp/bin        && \
    mv /tmp/bin /webapp/

WORKDIR /webapp

ENV RAILS_ENV production

CMD export DB_DATABASE=my_test_db                     && \
    export DB_USERNAME=root                           && \
    export DB_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD && \
    export DB_HOST=$MYSQL_PORT_3306_TCP_ADDR          && \
    export DB_PORT=$MYSQL_PORT_3306_TCP_PORT          && \
    bin/rake assets:precompile                        && \
    bin/rake db:migrate                               && \
    bin/puma

EXPOSE 9292
