FROM ruby:3.0.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn

RUN mkdir /body_order
WORKDIR /body_order

COPY Gemfile /body_order/Gemfile
COPY Gemfile.lock /body_order/Gemfile.lock
RUN bundle install
COPY . /body_order

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
#実行権限を付与
RUN chmod +x /usr/bin/entrypoint.sh
#一番最初に実行するコマンド(entrypoint.shを参照)
ENTRYPOINT ["entrypoint.sh"]
#コンテナがリッスンするport番号
EXPOSE 3000

#イメージ内部のソフトウェア(Rails)の実行
CMD ["rails", "server", "-b", "0.0.0.0"]
