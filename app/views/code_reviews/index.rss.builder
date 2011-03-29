xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Code Reviews'
    xml.description "Code Reviews for project: #{@project.name}"
    xml.link project_code_reviews_url(@project, :rss)
    xml.language 'en-us'

    for cr in @code_reviews
      xml.item do
        xml.title "Code Review ##{cr.id} in module '#{cr.module}'"
        xml.description cr.to_html, :type => 'html'
        xml.author 'TSYS PQA'
        xml.pubDate cr.updated_at.to_s(:rfc822)
        xml.link project_code_review_url(@project, cr)
        xml.guid project_code_review_url(@project, cr)
      end
    end
  end
end


