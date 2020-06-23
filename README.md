調味料を調整するサービス Chell's Kitchen
====

Overview
Chell's Kitchenは開発者が住んでいるチェルシーハウス国分寺発の調味料調整サービスです。\
\
<img width="1277" alt="スクリーンショット 2020-04-18 22 51 16" src="https://user-images.githubusercontent.com/45197982/79640279-ac764e00-81cb-11ea-9d8b-379375e6d46c.png">


## Description
Chell's Kitchenを使うと具体的に以下のことができるようになります。 \
・どこでも調味料の状態がわかる。 \
\
<img width="1278" alt="スクリーンショット 2020-04-18 22 53 01" src="https://user-images.githubusercontent.com/45197982/79640284-b26c2f00-81cb-11ea-9b19-cdfed04294cc.png"> \
\
・調味料のステータスを'1(赤色)'にすると、シェアハウス全員にメールで通知が入ります。 \
\
<img width="1276" alt="スクリーンショット 2020-04-18 22 53 15" src="https://user-images.githubusercontent.com/45197982/79640285-b435f280-81cb-11ea-983a-045c64e70b33.png">


・レシートの画像を投稿することで、管理者にレシートを送る手間が省けます。

使用技術
## 技術のこだわりポイント
### ローカルをDockerで構成
・ローカルの環境はRails(puma) + Nginx + MySQLで構成しています。

## 言語・フレームワーク・インフラ 

### バックエンド
Ruby 2.5.1 \
Ruby on Rails 5 

### フロントエンド
JavaScript \
jQuery

### 開発環境
Docker
docker-compose

### コンテナ構成
1. Rails(App) 
2. Nginx(Web) 
3. MySQL(DB) 

## その他
### URL
デプロイしていません。以前herokuデプロイ時.gitファイルが壊れてしまい、1から開発環境を作り直した苦い経験があるため、デプロイをしていません。 \
申し訳ありませんが、写真でアプリケーションのデザインだけでも掴んでください。 \
今後はherokuにデプロイ、また、AWS ECSを利用してデプロイ、Circle CI / CD を使用し、自動テスト/自動デプロイを行うなど、インフラ周りでアップデートしていく予定です。
