#何謂爬蟲？
Parser，解析器，簡單來說就是把「原本看不懂的東西」，轉換成看得懂，或者可以必利用的資料。

所謂網頁爬蟲，就是透過各種**字串尋找替換取代**布拉布拉步拉的各種方法分析網頁文本，獲得網頁內容感興趣的資訊。

最近因為想做Open Data，所以想爬點資料也是很正常的，既然 ruby 那麼好用，那就用吧 XD。

#環境
用了 Nokogiri 套件。

```bash
gem install nokogiri
```

即可。

#解說
我們使用以下的形式來載入網頁成 Nokogiri 提供的資料格式
```ruby
doc = Nokogiri::HTML(open('http://www.ntust.edu.tw/files/40-1000-167-1.php'))
```
其中 `open` 是 open-uri 提供的功能，負責把網頁抓下來，再交由 Nokogiri 解析。

解析完後就可以跟他玩啦，詳細可以看艾瑞克王的這篇：[Nokogiri 教學、簡介](http://wwssllabcd.github.io/blog/2012/10/25/how-to-use-nokogiri/)

用 xpath 之前也可先用 jQuery 的 selector玩玩網頁，在 Chrome 的
 Console 先試試看。使用 [jQuerify](https://chrome.google.com/webstore/detail/jquerify/gbmifchmngifmadobkcpijhhldeeelkc) Chrome Extension 讓任何網頁都可以使用 jQuery。
 
#用法
在 irb 中：
```ruby
require_relative 'parser.rb'

parser = NtustNews.new
parser.load_news

```

然後存取它：

```ruby
parser.news
parser.news[0]
parser.news.length
```
news是一包陣列，每一包大概長這樣
```ruby
{
    :short_title=>"我是新聞標題",
    :summary => "我是summary",
    :date => "2014-01-01",
    :url => "http://path_to_article_url",
    :title => "我是文章標題",
    :article => "我是文章內容哈哈哈"
 }
 ```
 一般 Hash 使用方式
```ruby
parser.news[0][:summary]
parser.news[0][:article]

```

#TODOs
* 文章應該用 HTML 的方式存，目前是存文字，表格那些都沒啦哈。
* Date 要轉成通用格式