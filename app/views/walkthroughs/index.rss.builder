xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Walkthrough Issues'
    xml.description "Walkthrough Issues for project: #{@project.name}"
    xml.link project_walkthroughs_url(@project, :rss)
    xml.language 'en-us'

    for w in @walkthroughs
      xml.item do
        xml.title "Walkthrough #{w.id}"
        xml.description w.to_html, :type => 'html'
        xml.author 'TSYS PQA'
        xml.pubDate w.updated_at.to_s(:rfc822)
        xml.link project_walkthrough_url(@project, w)
        xml.guid project_walkthrough_url(@project, w)
      end
    end
  end
end


