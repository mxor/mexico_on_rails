xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "México On Rails :: Aplicaciones %s" % ("por #{@user.login}" if @user)
    xml.description 'Evangelizando a México con Ruby on Rails'
    xml.link "http://mexicoonrails.com.mx"
    xml.language 'es-mx'
    xml.webmaster 'mxor@mexicoonrails.com.mx'

    for app in @apps
      xml.item do
        xml.title h(app.name)
        xml.description app.description + content_tag(:p, app.site_url)
        xml.pubDate app.created_at.to_s(:rfc822)
        xml.link app_url(app)
      end
    end
  end
end
