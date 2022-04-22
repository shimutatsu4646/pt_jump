FROM ruby:3.0.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn graphviz

RUN mkdir /pt_jump
WORKDIR /pt_jump

COPY Gemfile /pt_jump/Gemfile
COPY Gemfile.lock /pt_jump/Gemfile.lock
RUN bundle install
COPY . /pt_jump

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
