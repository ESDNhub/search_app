class SearchBuilder < Blacklight::SearchBuilder
  include Dbla::SearchBuilderBehavior
  
  def show_only_esdn solr_parameters
    solr_parameters[:fl] ||= []
    solr_parameters[:fl] << '[provider.name=Empire+State+Digital+Network'
  end
end
