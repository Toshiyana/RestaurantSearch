# RestaurantSearch
仕様書

## 作者
柳元俊輝

## アプリ名
<p> 酒グルメ </p>
<img src="https://raw.githubusercontent.com/wiki/Toshiyana/RestaurantSearch/images/Icon.jpg" width=150 >

## コンセプト
お酒好きのための飲食店検索アプリ。

## こだわったポイント
- 対象ユーザがお酒好きなので、飲食店の検索条件で距離以外にお酒に関する条件を入れた。
- お気に入り飲食店を登録できる機能の実装。
- 実務で利用ケースが多いとされる MVVM + RxSwift を採用。


## デザイン面でこだわったポイント
- お酒好きの大人を対象ユーザとしているので、夜っぽい雰囲気の色（オリジナルカラー）にした。
- おしゃれなアイコンを作成した。
- PKHUDライブラリを用いて、検索時の通信中のインジケータを表示した。
- ページネーション時はTableViewの下にインジケータを表示し、検索時とページネーション時で異なるをインジケータを用いた。
- アプリに柔らかい印象を与えるため、フィルターの条件ボタンやお気に入り追加ボタンの角を丸くした。

## 開発環境
### 開発環境
Xcode 13.4.1

### 開発言語
Swift 5.6.1

## 動作対象端末・OS
### 動作対象OS
iOS 15.5（それ以下のOSでは動作確認できていない）

## 開発期間
14日間 (7/5 ~ 7/19)

## アプリケーション機能

### 機能一覧
- レストラン検索：ホットペッパーグルメサーチAPIを使用して、現在地周辺の飲食店を検索する。
- レストラン情報取得：ホットペッパーグルメサーチAPIを使用して、飲食店の詳細情報を取得する。
- お気に入り登録：お気に入りの飲食店を詳細画面から登録できる。

### 画面一覧
- 検索一覧画面：条件を指定してレストランを検索し、検索結果を一覧表示する。
- 詳細画面：検索した飲食店の詳細情報を表示する画面.
- 検索条件画面：検索条件を指定する画面。
- お気に入りリスト画面：お気に入りに登録した飲食店の一覧を表示する。

| 検索一覧画面 | 詳細画面 | 検索条件画面 | お気に入りリスト画面 |
|:---:|:---:|:---:|:---:|
| <img src="https://raw.githubusercontent.com/wiki/Toshiyana/RestaurantSearch/images/ListVC.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/RestaurantSearch/images/DetailVC.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/RestaurantSearch/images/SearchFilterVC.png" width=220 > | <img src="https://raw.githubusercontent.com/wiki/Toshiyana/RestaurantSearch/images/FavoriteVC.png" width=220 > 

### 使用しているAPI,SDK,ライブラリなど
- ホットペッパーグルメサーチAPI
- SwiftLint
- RxSwift 
- RxCocoa
- Moya/RxSwift
- Kingfisher
- PKHUD
- RealmSwift


## アドバイスして欲しいポイント
- MVVM + RxSwiftの書き方（ObservableとSubjectの使い分け, 改善点など）
- 検索条件のボタンを押した時に、検索結果を更新したいが良い方法が思いつかなかった。（現状、検索条件を押した後、その条件を適用するために再度検索ボタンを押さないといけない。）具体的には、ListViewModel.swiftのプロパティのvar shops: Observable<[Shop]>を、SearchFilterViewModelからアクセスすれば実装できそうな感じはしたが、ViewModelから別のViewModelにアクセスするのは良くない気がしたので実装しなかった。

## 自己評価
MVVM + RxSwiftの理解と実装に時間がかかってしまったため、オリジナルの機能・デザインをあまり入れられなかった。以下が、時間があれば追加でやりたかったこと。

### 追加でやりたかったこと（今後実装すべき機能）
- アラートの表示
- 飲食店一覧画面で、お気に入り登録した飲食店のセルにお気に入りマークをつける。
- お気に入り登録した飲食店で、「お酒の充実度・お酒と料理の相性・メモ欄・自分で撮った写真」を登録できる機能の作成。
- 検索条件に飲食店のジャンルを入れる。
- 位置情報を用いた場合、ホットペッパーAPIのrangeのデフォルトが1000mなので、フィルター画面のデフォルトのrangeを1000mに設定。（やろうとしたが、うまくできなかった。）
- 検索時、現在地を用いるか否か選択できる。
- Map（MapKit or GoogleMap） を用いた検索。Mapに検索した飲食店をピン留め。ピンから飲食店の詳細画面へアクセス。
- アニメーション
- UnitTest

## 補足
動作を試す場合、ホットペーパーのAPIキーを取得して、自分で設定する必要あり。
（GitHub上の本プロジェクトにはAPIキーを含めていない。）
