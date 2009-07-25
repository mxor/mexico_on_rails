xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "México On Rails :: Artículos %s" % ("por #{@user.login}" if @user)
    xml.description 'Evangelizando a México con Ruby on Rails'
    xml.link "http://mexicoonrails.com.mx"
    xml.language 'es-mx'
    xml.webmaster 'mxor@mexicoonrails.com.mx'

    for article in @articles
      xml.item do
        xml.title h(article.title)
        xml.description article.excerpt
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link article_url(article.permalink)
      end
    end
  end
end
