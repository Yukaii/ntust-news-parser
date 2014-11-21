require 'nokogiri'
require 'open-uri'

class NtustNews

  attr_accessor :news, :news_urls

  def initialize
    @news = []
    @base_url = 'http://www.ntust.edu.tw/home.php'
  end


  def load_news
    home = Nokogiri::HTML(open(@base_url))

    @news_href = home.css('.news_pic')[0]['href']
    @news_url = URI.join(@base_url, @news_href).to_s

    news_page = Nokogiri::HTML(open(@news_url))

    @news_urls = news_page.css('#navigate .pagenum').map { |link| URI.join(@base_url, link['href']).to_s if link.inner_html.match(/^\d+$/) }.compact

    @news_urls.unshift @news_url unless @news_urls.include? @news_url

    @news_urls.each do |news_url|
      puts "Opening page #{news_url}..."

      doc = Nokogiri::HTML(open(news_url))

      t = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="h5"]')
      title_raws = t.map { |title| title.content.gsub(/\s+/, "") }
      t = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="h5"]//a/@href')
      urls = t.map { |url|  url.value}
      s = doc.xpath('//table[@summary="list"]//td[@valign="top"][not(@width)]//div[@class="message"]')
      summaries = s.map { |ss|  ss.text.gsub(/\s+/, "")}

      titles = title_raws.map { |t|
        start = t.index("[")
        endd = t.index("]")
        t[0..start-1]
      }

      dates = title_raws.map { |t|
        start = t.index("[")
        endd = t.index("]")
        t[start+1..endd-1]
      }


      for i in 0..titles.length-1
        h = Hash.new
        h[:short_title] = titles[i]
        h[:summary] = summaries[i]
        h[:date] = dates[i]
        h[:url] = urls[i]
        @news.push(h)
      end

      @news.each do |n|
        doc = Nokogiri::HTML(open(n[:url]))
        ps = doc.xpath('//div[contains(@class, "ptcontent")]//p')
        n[:title] = ps.first.text
        article = ""
        for i in 1..ps.length-1
          article += "#{ps[i].text}\n"
        end
        n[:article] = article
      end

    end
  end

end
