module DblaHelper
  include Dbla::ApplicationHelperBehavior

  def show_item_clean_title fld
    puts @document['sourceResource']['title']
    fld = @document['sourceResource']['title'][0]
  end

  def show_item_begin_date fld
    # TODO: check for date field before manipulating
    if !@document['sourceResource']['date'][0]['begin'].nil?
      first_date = @document['sourceResource']['date'][0]['begin'][0..3]
      second_date = @document['sourceResource']['date'][0]['end'][0..3]
      if first_date == second_date
        fld = first_date
      else
        fld = first_date + " - " + second_date
      end
    end
  end

  def build_dpla_link fld
    dpla_link = 'http://dp.la/item/' + @document['id']
    link_to dpla_link, dpla_link
  end

  def render_item_thumbnail_tag doc
    link_to image_tag(doc[:object]), doc[:isShownAt], :target => "_blank"
  end
end
