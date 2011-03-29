xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Unit Tests'
    xml.description "Unit Tests for project: #{@project.name}"
    xml.link project_unit_tests_url(@project, :rss)
    xml.language 'en-us'

    for utest in @utests
      xml.item do
        xml.title "Unit Test #{utest.fsd_usecase_id}: #{utest.module}"
        xml.description utest.to_html, :type => 'html'
        xml.author 'TSYS PQA'
        xml.pubDate utest.updated_at.to_s(:rfc822)
        xml.link project_unit_test_url(@project, utest)
        xml.guid project_unit_test_url(@project, utest)
      end
    end
  end
end


