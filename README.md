## 構築
```
$ docker compose build
```
```
$ docker compose run api rails db:create
```
```
$ docker compose up
```
=> http://0.0.0.0:6000

## 開発ルール
コミットする前に以下を実行してください！

### RuboCop
```
# docker compose exec api bashを実行した上で
bundle exec rubocop -a
```

docker込みなら
```
docker compose exec api bundle exec rubocop -a
```
