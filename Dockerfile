FROM ruby:2.5.1

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       nodejs

# ルート直下にwebappという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /chells-kitchen
WORKDIR /chells-kitchen

# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile /chells-kitchen/Gemfile
ADD Gemfile.lock /chells-kitchen/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . /chells-kitchen

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets

