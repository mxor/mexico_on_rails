xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "México On Rails :: Comentarios"
    xml.description 'Evangelizando a México con Ruby on Rails'
    xml.link "http://mexicoonrails.com.mx"
    xml.language 'es-mx'
    xml.webmaster 'mxor@mexicoonrails.com.mx'

    for comment in @approved_comments
      xml.item do
        xml.title "Comentario por #{h comment.name} en #{h comment.commentable_name_or_title}"
        xml.description comment.content
        xml.pubDate comment.created_at.to_s(:rfc822)
        xml.link commentable_url(comment)
      end
    end
  end
end
