module DblaHelper
  include Dbla::ApplicationHelperBehavior

  def show_item_clean_title fld
    puts @document['sourceResource']['title']
    fld = @document['sourceResource']['title'][0]
  end

  def build_dpla_link fld
    dpla_link = 'http://dp.la/item/' + @document['id']
    link_to dpla_link, dpla_link, :target => '_blank'
  end

  def build_dpla_api_link fld
    dpla_link = @document['@id'] + '?api_key=1c8a8b6674ef9508a55732256946895f'
    link_to @document['@id'], dpla_link, :target => '_blank'
  end

  def render_item_thumbnail_tag doc
    link_to image_tag(doc[:object]), doc[:isShownAt], :target => "_blank"
  end
end
