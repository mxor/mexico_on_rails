xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "México On Rails :: Noticias"
    xml.description 'Evangelizando a México con Ruby on Rails'
    xml.link "http://mexicoonrails.com.mx"
    xml.language 'es-mx'
    xml.webmaster 'mxor@mexicoonrails.com.mx'

    for new in @news
      xml.item do
        xml.title h(new.title)
        xml.description new.content
        xml.pubDate new.created_at.to_s(:rfc822)
        xml.link news_url(new)
      end
    end
  end
end
